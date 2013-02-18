module TF2LineParser
  module Events

    class RoleChange < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} changed role to #{regex_role}/
      end

      def self.regex_role
        @regex_role ||= '\"(?\'role\'.*)\"'
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :role]
      end

      attr_accessor :time, :player, :role

      def initialize(time, player_name, player_steam_id, player_team, role)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @role = role
      end

    end
  end
end
