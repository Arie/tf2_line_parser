module TF2LineParser
  module Events

    class Heal < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "healed" against #{regex_target} \(healing "(?'value'\d+)"\)/
      end

      def self.attributes
        @attributes ||= [:time, :player_steamid, :player_team, :target_steamid, :target_team, :value]
      end

      attr_accessor :time, :healer, :healer_team, :target, :target_team, :value

      def initialize(time, healer, healer_team, target, target_team, value)
        @time = parse_time(time)
        @healer = healer
        @healer_team = healer_team
        @target = target
        @target_team = target_team
        @value = value.to_i
      end
    end

  end
end
