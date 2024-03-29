# frozen_string_literal: true

module TF2LineParser
  module Events
    class Unknown < Event
      def self.regex
        @regex ||= /#{regex_time} #{regex_unknown}/.freeze
      end

      def self.regex_unknown
        "(?'unknown'.*)"
      end

      def self.attributes
        @attributes ||= %i[time unknown]
      end

      def initialize(time, unknown)
        @time = parse_time(time)
        @unknown = unknown
      end
    end
  end
end
