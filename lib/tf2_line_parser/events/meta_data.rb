# frozen_string_literal: true

module TF2LineParser
  module Events
    class MetaData < Event
      # A line can hold several properties; a title is free text, so never split
      PROPERTY = /\((\w+) "(.*?)"\)(?= \(\w+ "|\z)/.freeze

      # key and value are the first property
      attr_reader :time, :key, :value, :properties

      def self.regex
        @regex ||= /#{regex_time} World triggered "meta_data" \((?'key'\w+) "(?'value'.*)"\)/.freeze
      end

      def self.attributes
        @attributes ||= %i[time key value]
      end

      def initialize(time, key, value)
        @time = parse_time(time)
        @properties = split_properties(key, value)
        @key, @value = @properties.first
      end

      private

      def split_properties(key, value)
        return { key => value } if key == 'title'

        properties = "(#{key} \"#{value}\")".scan(PROPERTY).to_h
        properties.empty? ? { key => value } : properties
      end
    end
  end
end
