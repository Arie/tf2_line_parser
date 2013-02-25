module TF2LineParser
  module Events

    class RoundWin < RoundEventWithVariables

      def self.round_type
        @round_type ||= "Round_Win"
      end

      def self.round_variable_regex
        @round_variable_regex ||= /\(winner "(?'team'Red|Blue)"\)/
      end

      def self.round_variable
        @round_variable ||= :team
      end

    end

  end
end
