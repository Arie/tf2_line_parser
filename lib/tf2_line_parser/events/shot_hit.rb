# frozen_string_literal: true

module TF2LineParser
  module Events
    class ShotHit < PlayerActionEvent
      def self.action_text
        @action_text ||= 'triggered "shot_hit"'
      end

      def self.regex_action
        @regex_action ||= '\(weapon "(?\'weapon\'[^\"]+)"\)'
      end

      def self.item
        :weapon
      end

      def self.attributes
        @attributes ||= %i[time player_section weapon]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, weapon)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @weapon = weapon
      end
    end
  end
end
