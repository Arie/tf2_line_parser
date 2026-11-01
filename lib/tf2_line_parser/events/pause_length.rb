# frozen_string_literal: true

module TF2LineParser
  module Events
    class PauseLength < RoundEventWithVariables
      def self.round_type
        @round_type ||= 'Pause_Length'
      end

      def self.round_variable_regex
        @round_variable_regex ||= /\(seconds "(?'length'.*)"\)/.freeze
      end

      def self.round_variable
        @round_variable ||= :length
      end
    end
  end
end
