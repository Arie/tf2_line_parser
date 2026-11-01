# frozen_string_literal: true

module TF2LineParser
  module Events
    class GameUnpaused < RoundEventWithoutVariables
      def self.round_type
        @round_type ||= 'Game_Unpaused'
      end
    end
  end
end
