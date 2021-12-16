# frozen_string_literal: true

module TF2LineParser
  module Events
    class Score < Event
      def self.regex_score
        @regex_score ||= '\"(?\'score\'\d+)\"'
      end

      def self.regex_team
        @regex_team ||= 'Team \"(?\'team\'Red|Blue)\"'
      end

      def self.attributes
        @attributes ||= %i[time team score]
      end

      def initialize(time, team, score)
        @time = parse_time(time)
        @team = team
        @score = score
      end
    end
  end
end
