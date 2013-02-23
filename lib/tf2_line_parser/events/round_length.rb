module TF2LineParser
  module Events

    class RoundLength < Event

      def self.regex
        @regex ||= /#{regex_time} World triggered "Round_Length" \(seconds \"(?'length'.*)"\)/
      end

      def self.attributes
        @attributes ||= [:time, :length]
      end

      def initialize(time, length)
        @time = parse_time(time)
        @length = length
      end

    end

  end
end
