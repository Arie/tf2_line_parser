# frozen_string_literal: true

module TF2LineParser
  module Events
    class CaptureBlock < Event
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "captureblocked" #{regex_cap}/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section cp_number cp_name]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, cap_number, cap_name)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @cap_number = cap_number
        @cap_name = cap_name
      end
    end
  end
end
