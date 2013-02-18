module TF2LineParser
  module Events

    class RoundWin < Event

      def self.regex
        @regex ||= /#{regex_time} World triggered "Round_Win" \(winner "(?'team'Red|Blue)"\)/
      end

      def self.attributes
        @attributes ||= [:time, :team]
      end

      attr_accessor :winner

      def initialize(time, winner)
        @time = parse_time(time)
        @winner = winner
      end
    end

  end
end
