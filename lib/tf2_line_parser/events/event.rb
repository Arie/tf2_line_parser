module TF2LineParser

  module Events

    class Event

      attr_accessor :time, :type, :cap_number, :cap_name, :message, :unknown
      attr_accessor :team, :score, :value, :item, :role, :length, :method
      attr_accessor :player, :target


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
        @regex_cap ||= '\(cp "(?\'cp_number\'\d+)"\) \(cpname "(?\'cp_name\'.\w*)'
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
                    MedicDeath, RoleChange, Suicide, Say, TeamSay, Domination, Revenge, RoundWin, CurrentScore,
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

  end
end
