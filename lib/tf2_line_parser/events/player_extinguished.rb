module TF2LineParser
  module Events
    class PlayerExtinguished < Event
      attr_reader :time, :player, :target, :weapon

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "player_extinguished" against #{regex_target} with #{regex_weapon}#{regex_positions}?/.freeze
      end

      def self.regex_weapon
        @regex_weapon ||= '"(?\'weapon\'[^"]+)"'
      end

      def self.regex_positions
        @regex_positions ||= / \(attacker_position "[^"]+"\) \(victim_position "[^"]+"\)/
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
