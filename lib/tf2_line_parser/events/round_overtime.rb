# frozen_string_literal: true

module TF2LineParser
  module Events
    class RoundOvertime < RoundEventWithoutVariables
      def self.round_type
        @round_type ||= 'Round_Overtime'
      end
    end
  end
end
