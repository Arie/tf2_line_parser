# frozen_string_literal: true

module TF2LineParser
  module Events
    class RoleChange < PlayerActionEvent
      def self.action_text
        @action_text ||= 'changed role to'
      end

      def self.regex_action
        @regex_role ||= '\"(?\'role\'.*)\"'
      end

      def self.item
        :role
      end
    end
  end
end
