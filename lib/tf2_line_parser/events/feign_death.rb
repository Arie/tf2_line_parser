# frozen_string_literal: true

module TF2LineParser
  module Events
    class FeignDeath < PVPEvent
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} killed #{regex_target} #{regex_weapon} #{regex_customkill}/.freeze
      end

      def self.regex_weapon
        @regex_weapon ||= 'with "(?\'weapon\'\w*)"'
      end

      def self.regex_customkill
        @regex_customkill ||= /\(customkill "feign_death"\)/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section target_section weapon]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, target_name, target_uid, target_steam_id, target_team, weapon)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @target = Player.new(target_name, target_uid, target_steam_id, target_team)
        @weapon = weapon
      end
    end
  end
end
