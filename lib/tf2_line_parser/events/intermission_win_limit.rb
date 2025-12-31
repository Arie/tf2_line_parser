module TF2LineParser
  module Events
    class IntermissionWinLimit < Event
      attr_reader :time, :team, :reason

      def self.regex
        @regex ||= /#{regex_time} Team "(?'team'Red|Blue|RED|BLUE)" triggered "Intermission_Win_Limit" due to (?'reason'.*)/.freeze
      end

      def self.attributes
        @attributes ||= %i[time team reason]
      end

      def initialize(time, team, reason)
        @time = parse_time(time)
        @team = team
        @reason = reason
      end
    end
  end
end
