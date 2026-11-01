# frozen_string_literal: true

module TF2LineParser
  module Events
    class LoadingMap < Event
      attr_reader :time, :map

      def self.regex
        @regex ||= /#{regex_time} Loading map "(?'map'[^"]*)"/.freeze
      end

      def self.attributes
        @attributes ||= %i[time map]
      end

      def initialize(time, map)
        @time = parse_time(time)
        @map = map
      end
    end
  end
end
