# frozen_string_literal: true

module TF2LineParser
  module Events
    class ServerCvar < Event
      attr_reader :time, :name, :value

      def self.regex
        @regex ||= /#{regex_time} server_cvar: "(?'name'[^"]*)" "(?'value'.*)"/.freeze
      end

      def self.attributes
        @attributes ||= %i[time name value]
      end

      def initialize(time, name, value)
        @time = parse_time(time)
        @name = name
        @value = value
      end
    end
  end
end
