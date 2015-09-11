module TF2LineParser
  module Events

    class Suicide < PlayerActionEvent

      def self.action_text
        @action_text ||= "committed suicide with".freeze
      end

      def self.regex_action
        @regex_role ||= '\"(?\'method\'\w*)\"'.freeze
      end

      def self.item
        :method
      end

    end
  end
end
