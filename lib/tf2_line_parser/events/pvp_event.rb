module TF2LineParser

  module Events

    class PVPEvent < Event
      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :target_nick, :target_steamid, :target_team]
      end

      def initialize(time, player_name, player_steam_id, player_team, target_name, target_steam_id, target_team)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @target = Player.new(target_name, target_steam_id, target_team)
      end
    end
  end
end
