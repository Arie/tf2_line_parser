module TF2LineParser
  module Events

    class Score < Event

      def self.regex_score
        @regex_score ||= '\"(?\'score\'\d+)\"'.freeze
      end

      def self.regex_team
        @regex_team ||= 'Team \"(?\'team\'Red|Blue)\"'.freeze
      end

      def self.attributes
        @attributes ||= [:time, :team, :score]
      end

      def initialize(time, team, score)
        @time = parse_time(time)
        @team = team
        @score = score
      end

    end

  end
end
