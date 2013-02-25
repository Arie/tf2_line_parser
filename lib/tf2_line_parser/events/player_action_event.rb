module TF2LineParser

  module Events

    class PlayerActionEvent < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} #{action_text} #{regex_action}/
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, self.item]
      end

      def initialize(time, player_name, player_steam_id, player_team, item = self.class.item)
        @time = parse_time(time)
        @player = Player.new(player_name, player_steam_id, player_team)
        instance_variable_set("@#{self.class.item}", item)
      end

    end

    class PickupItem < PlayerActionEvent

      def self.action_text
        @action_text ||= "picked up item"
      end

      def self.regex_action
        @regex_item ||= '\"(?\'item\'.*)\"'
      end

      def self.item
        :item
      end

    end

    class RoleChange < PlayerActionEvent

      def self.action_text
        @action_text ||= "changed role to"
      end

      def self.regex_action
        @regex_role ||= '\"(?\'role\'.*)\"'
      end

      def self.item
        :role
      end

    end

    class Suicide < PlayerActionEvent

      def self.action_text
        @action_text ||= "committed suicide with"
      end

      def self.regex_action
        @regex_role ||= '\"(?\'method\'\w*)\"'
      end

      def self.item
        :method
      end

    end

  end
end
