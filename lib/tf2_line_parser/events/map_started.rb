# frozen_string_literal: true

module TF2LineParser
  module Events
    class MapStarted < Event
      attr_reader :time, :map, :crc

      def self.regex
        @regex ||= /#{regex_time} Started map "(?'map'[^"]*)" \(CRC "(?'crc'[^"]*)"\)/.freeze
      end

      def self.attributes
        @attributes ||= %i[time map crc]
      end

      def initialize(time, map, crc)
        @time = parse_time(time)
        @map = map
        @crc = crc
      end
    end
  end
end
