module TF2LineParser
  module Events

    class Spawn < PlayerActionEvent

      def self.action_text
        @action_text ||= "spawned as"
      end

      def self.regex_action
        @regex_item ||= '\"(?\'player_class\'.*)\"'
      end

      def self.item
        :player_class
      end

    end
  end
end
