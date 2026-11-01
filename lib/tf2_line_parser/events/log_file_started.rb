# frozen_string_literal: true

module TF2LineParser
  module Events
    class LogFileStarted < Event
      attr_reader :time, :file, :game, :version

      def self.regex
        @regex ||= /#{regex_time} Log file started \(file "(?'file'[^"]*)"\) \(game "(?'game'[^"]*)"\) \(version "(?'version'[^"]*)"\)/.freeze
      end

      def self.attributes
        @attributes ||= %i[time file game version]
      end

      def initialize(time, file, game, version)
        @time = parse_time(time)
        @file = file
        @game = game
        @version = version
      end
    end
  end
end
