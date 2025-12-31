module TF2LineParser
  module Events
    class MiniRoundStart < RoundEventWithoutVariables
      def self.round_type
        @round_type ||= 'Mini_Round_Start'
      end
    end
  end
end
