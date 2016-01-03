# frozen_string_literal: true
module TF2LineParser
  module Events

    class RoundStart < RoundEventWithoutVariables

      def self.round_type
        @round_type ||= "Round_Start".freeze
      end

    end

  end
end
