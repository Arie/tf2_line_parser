module TF2LineParser
  module Events

    class PickupItem < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} picked up item #{regex_item}/
      end

      def self.regex_item
        @regex_item ||= '\"(?\'item\'.*)\"'
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :item]
      end

      def initialize(time, player_name, player_steam_id, player_team, item)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        @item = item
      end

    end
  end
end
