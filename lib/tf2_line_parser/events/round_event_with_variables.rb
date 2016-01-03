# frozen_string_literal: true
module TF2LineParser
  module Events

    class RoundEventWithVariables < Event

      def self.regex
        @regex ||= /#{regex_time} World triggered "#{round_type}" #{round_variable_regex}/.freeze
      end

      def self.attributes
        @attributes ||= [:time, round_variable]
      end

      def initialize(time, round_variable)
        @time = parse_time(time)
        instance_variable_set("@#{self.class.round_variable}", round_variable)
      end

    end

  end
end
