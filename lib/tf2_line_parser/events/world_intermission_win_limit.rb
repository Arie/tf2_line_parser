# frozen_string_literal: true

module TF2LineParser
  module Events
    class WorldIntermissionWinLimit < RoundEventWithoutVariables
      def self.round_type
        @round_type ||= 'Intermission_Win_Limit'
      end
    end
  end
end
