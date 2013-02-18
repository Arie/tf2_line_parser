module TF2LineParser
  module Events


    class Chat < Event

      attr_accessor :time, :player, :team, :message

      def initialize(time, player, team, message)
        @time = parse_time(time)
        @player = player
        @team = team
        @message = message
      end

      def self.attributes
        @attributes ||= [:time, :player_steamid, :player_team, :message]
      end

    end

    class Say < Chat

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} say #{regex_message}/
      end

    end

    class TeamSay < Chat

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} say_team #{regex_message}/
      end

    end

  end
end
