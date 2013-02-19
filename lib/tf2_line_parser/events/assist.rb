module TF2LineParser
  module Events

    class Assist < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "kill assist" against #{regex_target}/
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :target_nick, :target_steamid, :target_team]
      end

      attr_accessor :time, :player, :target

      def initialize(time, assistant_name, assistant_steam_id, assistant_team, target_name, target_steam_id, target_team)
        @time = parse_time(time)
        @player = Player.new(assistant_name, assistant_steam_id, assistant_team)
        @target = Player.new(target_name, target_steam_id, target_team)
      end

    end

  end
end
