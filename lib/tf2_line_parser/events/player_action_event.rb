# frozen_string_literal: true

module TF2LineParser
  module Events
    class PlayerActionEvent < Event
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} #{action_text} #{regex_action}/.freeze
      end

      def self.attributes
        @attributes ||= [:time, :player_section, :item]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, item = self.class.item)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        instance_variable_set("@#{self.class.item}", item)
      end
    end
  end
end
