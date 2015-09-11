module TF2LineParser
  module Events

    class CaptureBlock < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "captureblocked" #{regex_cap}/.freeze
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :cp_number, :cp_name]
      end

      def initialize(time, player_name, player_steam_id, player_team, cap_number, cap_name)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @cap_number = cap_number
        @cap_name = cap_name
      end

    end

  end
end
