# frozen_string_literal: true

module TF2LineParser
  module Events
    class MetaData < Event
      attr_reader :time, :key, :value

      def self.regex
        @regex ||= /#{regex_time} World triggered "meta_data" \((?'key'\w+) "(?'value'.*)"\)/.freeze
      end

      def self.attributes
        @attributes ||= %i[time key value]
      end

      def initialize(time, key, value)
        @time = parse_time(time)
        @key = key
        @value = value
      end
    end
  end
end
