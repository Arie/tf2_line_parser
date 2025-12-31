# frozen_string_literal: true

module TF2LineParser
  module Events
    class HeadshotDamage < Damage
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "damage" #{regex_damage_against}\(damage "(?'value'\d+)"\)#{regex_realdamage}#{regex_weapon}#{regex_healing}#{regex_crit} #{regex_headshot}$/.freeze
      end

      def self.regex_headshot
        @regex_headshot ||= '\(headshot "(?\'headshot\'\d+)"\)'
      end

      def self.attributes
        @attributes ||= %i[time player_section target_section value weapon]
      end

      def self.regex_results(matched_line)
        time = matched_line['time']
        player_section = matched_line['player_section']
        target_section = matched_line['target_section']
        value = matched_line['value']
        weapon = matched_line['weapon']

        # Parse player section
        player_name, player_uid, player_steamid, player_team = parse_player_section(player_section)

        # Parse target section if present
        target_name, target_uid, target_steamid, target_team = nil, nil, nil, nil
        if target_section
          target_name, target_uid, target_steamid, target_team = parse_target_section(target_section)
        end

        [time, player_name, player_uid, player_steamid, player_team, target_name, target_uid, target_steamid, target_team, value, weapon]
      end

      def initialize(time, player_name, player_uid, player_steamid, player_team, target_name, target_uid, target_steamid, target_team, value, weapon)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steamid, player_team)
        @target = Player.new(target_name, target_uid, target_steamid, target_team) if target_name
        @value = value.to_i
        @damage = @value
        @weapon = weapon
        @healing = nil
        @crit = nil
        @headshot = true
      end
    end
  end
end
