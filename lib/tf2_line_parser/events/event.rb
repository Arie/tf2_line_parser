module TF2LineParser

  module Events

    class Event

      def self.time_format
        @time_format ||= '%m/%d/%Y - %T'
      end

      def self.regex_time
        @regex_time ||= 'L (?\'time\'.*):'
      end

      def self.regex_player
        @regex_player ||= '"(?\'player_nick\'.+)<(?\'player_uid\'\d+)><(?\'player_steamid\'STEAM_\S+)><(?\'player_team\'Red|Blue)>"'
      end

      def self.regex_target
        @regex_target ||= '"(?\'target_nick\'.+)<(?\'target_uid\'\d+)><(?\'target_steamid\'STEAM_\S+)><(?\'target_team\'Red|Blue)>"'
      end

      def self.regex_cap
        @regex_cap ||= '\(cp "(?\'cp_number\'\d+)"\) \(cpname "(?\'cp_name\'#\w*)'
      end

      def self.regex_console
        @regex_console ||= '"Console<0><Console><Console>"'
      end

      def self.regex_message
        @regex_message ||= '"(?\'message\'.*)"'
      end

      def self.types
        #ordered by how common the messages are
        @types ||= [Damage, Heal, PickupItem, Assist, Kill, CaptureBlock, PointCapture, ChargeDeployed,
                    MedicDeath, RoleChange, Say, TeamSay, Domination, Revenge, RoundWin, CurrentScore,
                    RoundLength, RoundStart, ConsoleSay, MatchEnd, FinalScore,
                    RoundStalemate, Unknown]
      end

      def self.regex_results(matched_line)
        attributes.collect do |attribute|
          matched_line[attribute]
        end
      end

      def parse_time(time_string)
        Time.strptime(time_string, Event.time_format)
      end

    end

    class PVPEvent < Event
      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :target_nick, :target_steamid, :target_team]
      end

      attr_accessor :time, :player, :target

      def initialize(time, player_name, player_steam_id, player_team, target_name, target_steam_id, target_team)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @target = Player.new(target_name, target_steam_id, target_team)
      end
    end

  end
end
