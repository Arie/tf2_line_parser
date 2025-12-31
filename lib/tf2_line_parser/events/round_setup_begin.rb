module TF2LineParser
  module Events
    class RoundSetupBegin < RoundEventWithoutVariables
      def self.round_type
        @round_type ||= 'Round_Setup_Begin'
      end
    end
  end
end
