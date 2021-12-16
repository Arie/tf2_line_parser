# frozen_string_literal: true

module TF2LineParser
  module Events
    class RconCommand < Event
      def self.regex
        @regex ||= /#{regex_time} rcon from #{regex_rcon}/.freeze
      end

      def self.regex_rcon
        @regex_rcon ||= '(?\'message\'.*")'
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
