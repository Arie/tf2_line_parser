module TF2LineParser
  module Events

    class PickupItem < PlayerActionEvent

      def self.action_text
        @action_text ||= "picked up item".freeze
      end

      def self.regex_action
        @regex_item ||= '\"(?\'item\'.*)\"'.freeze
      end

      def self.item
        :item
      end

    end
  end
end
