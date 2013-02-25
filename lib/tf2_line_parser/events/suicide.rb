module TF2LineParser
  module Events

    class Suicide < PlayerActionEvent

      def self.action_text
        @action_text ||= "committed suicide with"
      end

      def self.regex_action
        @regex_role ||= '\"(?\'method\'\w*)\"'
      end

      def self.item
        :method
      end

    end
  end
end
