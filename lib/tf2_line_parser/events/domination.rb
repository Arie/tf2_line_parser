module TF2LineParser
  module Events

    class Domination < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "domination" against #{regex_target}.*/
      end

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
