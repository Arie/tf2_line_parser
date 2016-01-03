# frozen_string_literal: true
module TF2LineParser
  module Events

    class Heal < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "healed" against #{regex_target} \(healing "(?'value'\d+)"\)/.freeze
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :target_nick, :target_steamid, :target_team, :value]
      end

      def initialize(time, player_name, player_steam_id, player_team, target_name, target_steam_id, target_team, value)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @target = Player.new(target_name, target_steam_id, target_team)
        @value = value.to_i
      end
    end

  end
end
