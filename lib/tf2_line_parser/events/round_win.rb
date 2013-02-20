module TF2LineParser
  module Events

    class RoundWin < Event

      def self.regex
        @regex ||= /#{regex_time} World triggered "Round_Win" \(winner "(?'team'Red|Blue)"\)/
      end

      def self.attributes
        @attributes ||= [:time, :team]
      end

      attr_accessor :time, :team

      def initialize(time, team)
        @time = parse_time(time)
        @team = team
      end
    end

  end
end
