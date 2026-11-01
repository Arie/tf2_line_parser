# frozen_string_literal: true

module TF2LineParser
  module Events
    class ObjectEvent < Event
      attr_reader :time, :player, :object, :position

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "#{keyword}" \(object "(?'object'[^"]+)"\)(?: \(position "(?'position'[^"]+)"\))?/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section object position]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, object, position)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @object = object
        @position = position
      end
    end
  end
end
