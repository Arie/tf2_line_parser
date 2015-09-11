module TF2LineParser
  module Events

    class CurrentScore < Score

      def self.regex
        @regex ||= /#{regex_time} #{regex_team} current score #{regex_score} with .*/.freeze
      end

    end

  end
end
