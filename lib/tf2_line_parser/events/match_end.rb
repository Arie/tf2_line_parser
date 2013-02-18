module TF2LineParser
  module Events

    class MatchEnd < Event

      def self.regex
        @regex ||= /#{regex_time} World triggered "Game_Over" reason "(?'reason'.*)"/
      end

      def self.attributes
        @attributes ||= [:time, :reason]
      end

      attr_accessor :time, :reason

      def initialize(time, reason)
        @time = parse_time(time)
        @reason = reason
      end

    end

  end
end
