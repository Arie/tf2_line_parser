# frozen_string_literal: true

module TF2LineParser
  module Events
    class ConsoleSay < Event
      def self.regex
        @regex ||= /#{regex_time} #{regex_console} say #{regex_message}/.freeze
      end

      def self.attributes
        @attributes ||= %i[time message]
      end

      def initialize(time, message)
        @time = parse_time(time)
        @message = message
      end
    end
  end
end
