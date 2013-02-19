module TF2LineParser
  module Events

    class Damage < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "damage" \(damage "(?'value'\d+)"\)/
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :value]
      end

      attr_accessor :time, :player, :value

      def initialize(time, player_name, player_steam_id, player_team, value)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @value = value.to_i
      end

    end
  end
end
