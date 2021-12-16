# frozen_string_literal: true

module TF2LineParser
  module Events
    class Airshot < Damage
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "damage" #{regex_damage_against}\(damage "(?'value'\d+)"\)(?:( #{regex_realdamage})?( #{regex_weapon})?( #{regex_airshot})?)$/.freeze
      end

      def self.regex_airshot
        @regex_airshot ||= /(\(airshot "(?'airshot'\w*)"\))?/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_nick player_steamid player_team target_nick target_steamid
                           target_team value weapon airshot]
      end

      def initialize(time, player_name, player_steamid, player_team, target_name, target_steamid, target_team, value, weapon, airshot)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steamid, player_team)
        @target = Player.new(target_name, target_steamid, target_team) if target_name
        @value = value.to_i
        @weapon = weapon
        @airshot = (airshot.to_i == 1)
      end
    end
  end
end
