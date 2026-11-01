# frozen_string_literal: true

module TF2LineParser
  module Events
    class LogFileClosed < Event
      def self.regex
        @regex ||= /#{regex_time} Log file closed\.?\s*$/.freeze
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
