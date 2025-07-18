# frozen_string_literal: true

module TF2LineParser
  module Events
    class Suicide < PlayerActionEvent
      def self.action_text
        @action_text ||= 'committed suicide with'
      end

      def self.regex_action
        @regex_role ||= '\"(?\'method\'\w*)\"'
      end

      def self.item
        :method
      end

      def self.attributes
        @attributes ||= %i[time player_section method]
      end
    end
  end
end
