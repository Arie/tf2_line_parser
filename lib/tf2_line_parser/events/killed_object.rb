module TF2LineParser
  module Events
    class KilledObject < Event
      attr_reader :time, :player, :object, :weapon, :objectowner

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "killedobject" #{regex_object_info}#{regex_attacker_position}?/.freeze
      end

      def self.regex_object_info
        @regex_object_info ||= '\(object "(?\'object\'[^"]+)"\) \(weapon "(?\'weapon\'[^"]+)"\) \(objectowner "(?\'objectowner_section\'.*?)"\)'
      end

      def self.regex_attacker_position
        @regex_attacker_position ||= / \(attacker_position "[^"]+"\)/
      end

      def self.attributes
        @attributes ||= %i[time player_section object weapon objectowner_section]
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
          when :objectowner_section
            if matched_line['objectowner_section']
              out.concat(parse_player_section(matched_line['objectowner_section']))
            else
              out.concat([nil, nil, nil, nil])
            end
          else
            out << matched_line[attribute]
          end
        end
        out
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, object, weapon, objectowner_name, objectowner_uid, objectowner_steam_id, objectowner_team)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @object = object
        @weapon = weapon
        @objectowner = Player.new(objectowner_name, objectowner_uid, objectowner_steam_id, objectowner_team)
      end
    end
  end
end
