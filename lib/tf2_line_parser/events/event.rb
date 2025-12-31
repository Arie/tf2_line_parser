# frozen_string_literal: true

module TF2LineParser
  module Events
    class Event
      attr_accessor :time, :type, :cap_number, :cap_name, :message, :unknown, :team, :score, :value, :item, :role,
                    :length, :method, :player, :target, :healing, :ubercharge, :customkill, :weapon, :airshot

      def self.time_format
        @time_format ||= '%m/%d/%Y - %T'
      end

      def self.regex_time
        @regex_time ||= 'L (?\'time\'.*):'
      end

      def self.regex_player
        @regex_player ||= /"(?<player_section>.*?)"/
      end

      def self.regex_target
        @regex_target ||= /"(?<target_section>.*?)"/
      end

      def self.regex_cap
        @regex_cap ||= '\(cp "(?\'cp_number\'\d+)"\) \(cpname "(?\'cp_name\'.\w*)'
      end

      def self.regex_console
        @regex_console ||= '"Console<0><Console><Console>"'
      end

      def self.regex_message
        @regex_message ||= '"(?\'message\'.*)"'
      end

      def self.types
        # ordered by how common the messages are
        @types ||= [Damage, Heal, PickupItem, Assist, Kill, CaptureBlock, PointCapture, ChargeDeployed,
                    MedicDeath, MedicDeathEx, EmptyUber, ChargeReady, ChargeEnded, FirstHealAfterSpawn, LostUberAdvantage, RoleChange, Spawn, Airshot, HeadshotDamage, Suicide, KilledObject, Say, TeamSay, Domination, Revenge, RoundWin, CurrentScore,
                    RoundLength, RoundStart, Connect, Disconnect, RconCommand, ConsoleSay, MatchEnd, FinalScore,
                    RoundStalemate, Unknown].freeze
      end

      def self.regex_results(matched_line)
        out = []
        attributes.each do |attribute|
          case attribute
          when :player_section
            if matched_line['player_section']
              out.concat(parse_player_section(matched_line['player_section']))
            else
              out.concat([nil, nil, nil, nil])
            end
          when :target_section
            if matched_line['target_section']
              out.concat(parse_target_section(matched_line['target_section']))
            else
              out.concat([nil, nil, nil, nil])
            end
          else
            out << matched_line[attribute]
          end
        end
        out
      end

      def parse_time(time_string)
        Time.strptime(time_string, Event.time_format)
      end

      def self.parse_player_section(section)
        return [nil, nil, nil, nil] unless section

        # Find all <...> groups in the section
        parts = section.scan(/<([^>]*)>/)
        return [nil, nil, nil, nil] if parts.length < 2

        # For the cheeky name tests, we need to find the last complete set of uid/steamid/team
        # Look for the pattern: <uid><steamid><team> at the end
        if parts.length >= 3
          # Try to find the last complete set of 3 groups
          # Start from the end and work backwards
          last_valid_set = nil
          (parts.length - 2).downto(0) do |i|
            if i + 2 < parts.length
              uid = parts[i][0]
              steamid = parts[i + 1][0]
              team = parts[i + 2][0]

              # Check if this looks like a valid set (uid is numeric, steamid looks like steam id, team is valid)
              if uid.match?(/^\d+$/) && (steamid.start_with?('STEAM_') || steamid.start_with?('[U:')) && ['Red', 'Blue', 'Unassigned', 'Spectator', ''].include?(team)
                # This looks like a valid player info set
                last_valid_set = [i, uid, steamid, team]
                break  # Take the last (rightmost) valid set
              end
            end
          end

          if last_valid_set
            i, uid, steamid, team = last_valid_set
            # The name is everything before the first <...> group of this set
            uid_start = section.index("<#{uid}>")
            if uid_start
              name = section[0...uid_start]
              return [name, uid, steamid, team]
            end
          end
        end

        # Handle cases with 2 or 3 groups (normal case)
        if parts.length == 2
          # Only uid and steamid, no team
          uid = parts[0][0]
          steamid = parts[1][0]
          team = ""
        else
          # uid, steamid, and team
          uid = parts[-3][0]
          steamid = parts[-2][0]
          team = parts[-1][0]
        end

        # The name is everything before the first <...> group
        name_end = section.index("<#{uid}>")
        return [nil, nil, nil, nil] unless name_end

        name = section[0...name_end]

        [name, uid, steamid, team]
      end

      def self.parse_target_section(section)
        return [nil, nil, nil, nil] unless section

        # Same logic as player but for targets
        parts = section.scan(/<([^>]*)>/)
        return [nil, nil, nil, nil] if parts.length < 2

        # Handle cases with 2 or 3 groups
        if parts.length == 2
          # Only uid and steamid, no team
          uid = parts[0][0]
          steamid = parts[1][0]
          team = ""
        else
          # uid, steamid, and team
          uid = parts[-3][0]
          steamid = parts[-2][0]
          team = parts[-1][0]
        end

        # The name is everything before the first <...> group
        name_end = section.index("<#{uid}>")
        return [nil, nil, nil, nil] unless name_end

        name = section[0...name_end]

        [name, uid, steamid, team]
      end
    end
  end
end
