module TF2LineParser
  module Events
    class RoundSetupEnd < RoundEventWithoutVariables
      def self.round_type
        @round_type ||= 'Round_Setup_End'
      end
    end
  end
end
