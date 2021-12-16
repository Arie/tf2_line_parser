# frozen_string_literal: true

module TF2LineParser
  module Events
    class HeadshotDamage < Damage
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "damage" #{regex_damage_against}\(damage "(?'value'\d+)"\)(?:( #{regex_realdamage})?( #{regex_weapon})?) #{regex_headshot}$/.freeze
      end

      def self.regex_headshot
        @regex_headshot ||= '\(headshot "(?\'headshot\'\d+)"\)'
      end

      def self.attributes
        @attributes ||= %i[time player_nick player_steamid player_team target_nick target_steamid
                           target_team value weapon]
      end

      def initialize(time, player_name, player_steamid, player_team, target_name, target_steamid, target_team, value, weapon)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steamid, player_team)
        @target = Player.new(target_name, target_steamid, target_team) if target_name
        @value = value.to_i
        @weapon = weapon
      end
    end
  end
end
