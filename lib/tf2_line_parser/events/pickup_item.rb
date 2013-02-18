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
        @attributes ||= [:time, :player_steamid, :player_team, :item]
      end

      attr_accessor :time, :player, :team, :item

      def initialize(time, player, team, item)
        @time = parse_time(time)
        @player = player
        @team = team
        @item = item
      end

    end
  end
end
