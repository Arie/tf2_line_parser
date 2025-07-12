# frozen_string_literal: true

module TF2LineParser
  module Events
    class Revenge < PVPEvent
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "revenge" against #{regex_target}.*/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section target_section]
      end
    end
  end
end
