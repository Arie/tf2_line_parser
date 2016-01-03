# frozen_string_literal: true
module TF2LineParser
  module Events

    class MedicDeath < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "medic_death" against #{regex_target} #{regex_medic_death_info}/.freeze
      end

      def self.regex_medic_death_info
        @regex_healing ||= '\(healing "(?\'healing\'\d+)"\) \(ubercharge "(?\'ubercharge\'\d+)"\)'.freeze
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :target_nick, :target_steamid, :target_team, :healing, :ubercharge]
      end

      def initialize(time, player_name, player_steam_id, player_team, target_name, target_steam_id, target_team, healing, ubercharge)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @target = Player.new(target_name, target_steam_id, target_team)
        @healing = healing.to_i
        @ubercharge = (ubercharge == "1")
      end

    end
  end
end
