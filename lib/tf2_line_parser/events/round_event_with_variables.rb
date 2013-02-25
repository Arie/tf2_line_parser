module TF2LineParser
  module Events

    class RoundEventWithVariables < Event

      def self.regex
        @regex ||= /#{regex_time} World triggered "#{round_type}" #{round_variable_regex}/
      end

      def self.attributes
        @attributes ||= [:time, round_variable]
      end

      def initialize(time, round_variable)
        @time = parse_time(time)
        instance_variable_set("@#{self.class.round_variable}", round_variable)
      end

    end

    class RoundLength < RoundEventWithVariables

      def self.round_type
        @round_type ||= "Round_Length"
      end

      def self.round_variable
        @round_variable ||= :length
      end

      def self.round_variable_regex
        @round_variable_regex ||= /\(seconds \"(?'length'.*)"\)/
      end

    end

    class MatchEnd < RoundEventWithVariables

      def self.round_type
        "Game_Over"
      end

      def self.round_variable
        @round_variable ||= :reason
      end

      def self.round_variable_regex
        @round_variable_regex ||= /reason "(?'reason'.*)"/
      end

    end

    class RoundWin < RoundEventWithVariables

      def self.round_type
        @round_type ||= "Round_Win"
      end

      def self.round_variable
        @round_variable ||= :team
      end

      def self.round_variable_regex
        @round_variable_regex ||= /\(winner "(?'team'Red|Blue)"\)/
      end

    end

  end
end
