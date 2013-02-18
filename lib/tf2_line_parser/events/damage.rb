module TF2LineParser
  module Events

    class Damage < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "damage" \(damage "(?'value'\d+)"\)/
      end

      def self.attributes
        @attributes ||= [:time, :player_steamid, :player_team, :value]
      end

      attr_accessor :time, :team, :player, :value

      def initialize(time, team, player, value)
        @time = parse_time(time)
        @team = team
        @player = player
        @value = value.to_i
      end

    end
  end
end
