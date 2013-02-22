module TF2LineParser
  module Events

    class Suicide < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} committed suicide with #{regex_suicide}/
      end

      def self.regex_suicide
        @regex_role ||= '\"(?\'method\'\w*)\"'
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :method]
      end

      def initialize(time, player_name, player_steam_id, player_team, method)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @method = method
      end

    end
  end
end
