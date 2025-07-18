# frozen_string_literal: true

module TF2LineParser
  module Events
    class PickupItem < PlayerActionEvent
      def self.action_text
        @action_text ||= 'picked up item'
      end

      def self.regex_action
        @regex_item ||= '\"(?\'item\'.*)\"'
      end

      def self.item
        :item
      end

      def self.attributes
        @attributes ||= %i[time player_section item]
      end
    end
  end
end
