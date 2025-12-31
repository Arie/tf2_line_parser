# frozen_string_literal: true

module TF2LineParser
  module Events
    class Damage < Event
      attr_reader :crit, :headshot, :healing

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "damage" #{regex_damage_against}\(damage "(?'value'\d+)"\)#{regex_realdamage}#{regex_weapon}#{regex_healing}#{regex_crit}#{regex_headshot}/.freeze
      end

      def self.regex_damage_against
        @regex_damage_against ||= /(against #{regex_target} )?/.freeze
      end

      def self.regex_realdamage
        @regex_realdamage ||= /(?: \(realdamage "(?'realdamage'\d*)"\))?/.freeze
      end

      def self.regex_weapon
        @regex_weapon ||= /(?: \(weapon "(?'weapon'[^"]*)"\))?/.freeze
      end

      def self.regex_healing
        @regex_healing ||= /(?: \(healing "(?'healing'\d*)"\))?/.freeze
      end

      def self.regex_crit
        @regex_crit ||= /(?: \(crit "(?'crit'[^"]*)"\))?/.freeze
      end

      def self.regex_headshot
        @regex_headshot ||= /(?: \(headshot "(?'headshot'\d*)"\))?/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section target_section value weapon healing crit headshot]
      end

      def self.regex_results(matched_line)
        time = matched_line['time']
        player_section = matched_line['player_section']
        target_section = matched_line['target_section']
        value = matched_line['value']
        weapon = matched_line['weapon']
        healing = matched_line['healing']
        crit = matched_line['crit']
        headshot = matched_line['headshot']

        # Parse player section
        player_name, player_uid, player_steamid, player_team = parse_player_section(player_section)

        # Parse target section if present
        target_name, target_uid, target_steamid, target_team = nil, nil, nil, nil
        if target_section
          target_name, target_uid, target_steamid, target_team = parse_target_section(target_section)
        end

        [time, player_name, player_uid, player_steamid, player_team, target_name, target_uid, target_steamid, target_team, value, weapon, healing, crit, headshot]
      end

      def initialize(time, player_name, player_uid, player_steamid, player_team, target_name, target_uid, target_steamid, target_team, value, weapon, healing, crit, headshot)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steamid, player_team)
        @target = Player.new(target_name, target_uid, target_steamid, target_team) if target_name
        @value = value.to_i
        @weapon = weapon
        @healing = healing.to_i if healing
        @crit = crit
        @headshot = headshot == '1'
      end
    end
  end
end
