# frozen_string_literal: true

module TF2LineParser
  module Events
    class GamePaused < RoundEventWithoutVariables
      def self.round_type
        @round_type ||= 'Game_Paused'
      end
    end
  end
end
