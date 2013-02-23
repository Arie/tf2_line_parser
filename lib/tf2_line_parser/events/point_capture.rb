module TF2LineParser
  module Events

    class PointCapture < Event

      def self.regex
        @regex ||= /#{regex_time} Team "(?'team'Red|Blue)" triggered "pointcaptured" \(cp "(?'cp_number'\d+)"\) \(cpname "(?'cp_name'.*)"\) \(numcappers/
      end

      def self.attributes
        @attributes ||= [:time, :team, :cp_number, :cp_name]
      end

      def initialize(time, team, cap_number, cap_name)
        @time = parse_time(time)
        @team = team
        @cap_number = cap_number
        @cap_name = cap_name
      end

    end

  end
end
