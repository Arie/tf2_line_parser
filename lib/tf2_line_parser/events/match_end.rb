module TF2LineParser
  module Events

    class MatchEnd < RoundEventWithVariables

      def self.round_variable_regex
        @round_variable_regex ||= /reason "(?'reason'.*)"/.freeze
      end

      def self.round_type
        "Game_Over"
      end

      def self.round_variable
        @round_variable ||= :reason
      end

    end

  end
end
