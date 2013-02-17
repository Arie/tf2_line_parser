module TF2LineParser
  module Events

    class RoundWin

      attr_accessor :winner

      def initialize(winner)
        @winner = winner
      end
    end

  end
end
