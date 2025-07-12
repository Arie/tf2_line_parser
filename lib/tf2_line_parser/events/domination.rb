# frozen_string_literal: true

module TF2LineParser
  module Events
    class Domination < PVPEvent
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "domination" against #{regex_target}.*/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section target_section]
      end
    end
  end
end
