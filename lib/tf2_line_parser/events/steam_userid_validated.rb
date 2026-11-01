# frozen_string_literal: true

module TF2LineParser
  module Events
    class SteamUseridValidated < Event
      attr_reader :time, :player

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} STEAM USERID validated\s*$/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
      end
    end
  end
end
