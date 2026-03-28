# frozen_string_literal: true

module TF2LineParser
  module Events
    class MiniRoundWin < RoundEventWithVariables
      def self.round_type
        @round_type ||= 'Mini_Round_Win'
      end

      def self.round_variable_regex
        @round_variable_regex ||= /\(winner "(?'team'Red|Blue)"\)/.freeze
      end

      def self.round_variable
        @round_variable ||= :team
      end
    end
  end
end
