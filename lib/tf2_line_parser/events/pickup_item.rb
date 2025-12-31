# frozen_string_literal: true

module TF2LineParser
  module Events
    class PickupItem < PlayerActionEvent
      def self.action_text
        @action_text ||= 'picked up item'
      end

      def self.regex_action
        @regex_item ||= '\"(?\'item\'[^\"]+)\"(?: \\(healing \"(?\'value\'\\d+)\"\\))?'
      end

      def self.item
        :item
      end

      def self.attributes
        @attributes ||= %i[time player_section item value]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, item, value = nil)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @item = item
        @value = value&.to_i
        @healing = @value
      end
    end
  end
end
