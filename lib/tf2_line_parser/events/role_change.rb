module TF2LineParser
  module Events

    class RoleChange < PlayerActionEvent

      def self.action_text
        @action_text ||= "changed role to".freeze
      end

      def self.regex_action
        @regex_role ||= '\"(?\'role\'.*)\"'.freeze
      end

      def self.item
        :role
      end

    end
  end
end
