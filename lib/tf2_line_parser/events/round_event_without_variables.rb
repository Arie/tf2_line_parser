module TF2LineParser
  module Events

    class RoundEventWithoutVariables < Event

      def self.regex
        @regex ||= /#{regex_time} World triggered "#{round_type}"/
      end

      def self.attributes
        @attributes ||= [:time]
      end

      def initialize(time)
        @time = parse_time(time)
      end

    end

  end
end
