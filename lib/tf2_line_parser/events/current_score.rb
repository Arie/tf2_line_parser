module TF2LineParser
  module Events

    class CurrentScore < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_team} #{regex_current_score} with .*/
      end

      def self.regex_current_score
        @regex_score ||= 'current score \"(?\'score\'\d+)\"'
      end

      def self.regex_team
        @regex_team ||= 'Team \"(?\'team\'Red|Blue)\"'
      end

      def self.attributes
        @attributes ||= [:time, :team, :score]
      end

      attr_accessor :time, :team, :score

      def initialize(time, team, score)
        @time = parse_time(time)
        @team = team
        @score = score
      end
    end

  end
end
