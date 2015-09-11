module TF2LineParser
  module Events

    class Damage < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "damage" #{regex_damage_against}\(damage "(?'value'\d+)"\)(?:( #{regex_realdamage})?( #{regex_weapon})?)$/.freeze
      end

      def self.regex_damage_against
        @regex_damage_against ||= /(against #{regex_target} )?/.freeze
      end

      def self.regex_realdamage
        @regex_realdamage ||= /(\(realdamage "(?'realdamage'\w*)"\))?/.freeze
      end

      def self.regex_weapon
        @regex_weapon ||= /(\(weapon "(?'weapon'\w*)"\))?/.freeze
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :target_nick, :target_steamid, :target_team, :value, :weapon]
      end

      def initialize(time, player_name, player_steamid, player_team, target_name, target_steamid, target_team, value, weapon)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steamid, player_team)
        if target_name
          @target = Player.new(target_name, target_steamid, target_team)
        end
        @value = value.to_i
        @weapon = weapon
      end

    end
  end
end
