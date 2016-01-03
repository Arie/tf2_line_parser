# frozen_string_literal: true
module TF2LineParser
  module Events

    class RoundWin < RoundEventWithVariables

      def self.round_type
        @round_type ||= "Round_Win".freeze
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
