# frozen_string_literal: true

module TF2LineParser
  module Events
    class FinalScore < Score
      def self.regex
        @regex ||= /#{regex_time} #{regex_team} final score #{regex_score} with .*/.freeze
      end
    end
  end
end
