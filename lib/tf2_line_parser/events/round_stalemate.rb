module TF2LineParser
  module Events

    class RoundStalemate < Event

      def self.regex
        @regex ||= /#{regex_time} World triggered "Round_Stalemate"/
      end

      def self.attributes
        @attributes ||= [:time]
      end

      attr_accessor :time

      def initialize(time)
        @time = parse_time(time)
      end

    end

  end
end
