# frozen_string_literal: true

module TF2LineParser
  module Events
    class Damage < Event
      attr_reader :damage, :realdamage, :crit, :headshot, :healing

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "damage" #{regex_damage_against}\(damage "(?'value'\d+)"\)#{regex_realdamage}#{regex_weapon}#{regex_healing}#{regex_crit}#{regex_headshot}/
      end

      def self.regex_damage_against
        @regex_damage_against ||= /(against #{regex_target} )?/
      end

      def self.regex_realdamage
        @regex_realdamage ||= /(?: \(realdamage "(?'realdamage'\d*)"\))?/
      end

      def self.regex_weapon
        @regex_weapon ||= /(?: \(weapon "(?'weapon'[^"]*)"\))?/
      end

      def self.regex_healing
        @regex_healing ||= /(?: \(healing "(?'healing'\d*)"\))?/
      end

      def self.regex_crit
        @regex_crit ||= /(?: \(crit "(?'crit'[^"]*)"\))?/
      end

      def self.regex_headshot
        @regex_headshot ||= /(?: \(headshot "(?'headshot'\d*)"\))?/
      end

      def self.attributes
        @attributes ||= %i[time player_section target_section value realdamage weapon healing crit headshot]
      end

      def self.regex_results(matched_line)
        time = matched_line['time']
        player_section = matched_line['player_section']
        target_section = matched_line['target_section']
        value = matched_line['value']
        realdamage = matched_line['realdamage']
        weapon = matched_line['weapon']
        healing = matched_line['healing']
        crit = matched_line['crit']
        headshot = matched_line['headshot']

        # Parse player section
        player_name, player_uid, player_steamid, player_team = parse_player_section(player_section)

        # Parse target section if present
        target_name = nil
        target_uid = nil
        target_steamid = nil
        target_team = nil
        target_name, target_uid, target_steamid, target_team = parse_target_section(target_section) if target_section

        [time, player_name, player_uid, player_steamid, player_team, target_name, target_uid, target_steamid, target_team, value, realdamage, weapon, healing, crit, headshot]
      end

      def initialize(time, player_name, player_uid, player_steamid, player_team, target_name, target_uid, target_steamid, target_team, value, realdamage, weapon, healing, crit, headshot)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steamid, player_team)
        @target = Player.new(target_name, target_uid, target_steamid, target_team) if target_name
        @value = value.to_i
        @damage = @value
        @realdamage = realdamage.to_i if realdamage && !realdamage.empty?
        @weapon = weapon
        @healing = healing.to_i if healing
        @crit = crit
        @headshot = (headshot == '1') if headshot
      end
    end
  end
end
