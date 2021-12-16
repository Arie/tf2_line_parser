# frozen_string_literal: true

module TF2LineParser
  module Events
    class Disconnect < Event
      def initialize(time, player_name, player_steam_id, player_team, message)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @message = message
      end

      def self.attributes
        @attributes ||= %i[time player_nick player_steamid player_team message]
      end

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} disconnected \(reason #{regex_message}\)/.freeze
      end
    end
  end
end
