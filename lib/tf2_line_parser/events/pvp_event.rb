# frozen_string_literal: true

module TF2LineParser
  module Events
    class PVPEvent < Event
      def self.attributes
        @attributes ||= %i[time player_section target_section]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, target_name, target_uid, target_steam_id, target_team)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @target = Player.new(target_name, target_uid, target_steam_id, target_team)
      end
    end
  end
end
