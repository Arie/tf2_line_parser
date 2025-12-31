module TF2LineParser
  module Events
    class MiniRoundSelected < RoundEventWithVariables
      def self.round_variable_regex
        @round_variable_regex ||= /\(round "(?'round'.*)"\)/.freeze
      end

      def self.round_type
        'Mini_Round_Selected'
      end

      def self.round_variable
        @round_variable ||= :round
      end
    end
  end
end
