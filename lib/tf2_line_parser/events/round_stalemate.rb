# frozen_string_literal: true
module TF2LineParser
  module Events

    class RoundStalemate < RoundEventWithoutVariables

      def self.round_type
        @round_type ||= "Round_Stalemate".freeze
      end

    end

  end
end
