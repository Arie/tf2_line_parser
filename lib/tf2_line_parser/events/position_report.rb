# frozen_string_literal: true

module TF2LineParser
  module Events
    class PositionReport < Event
      attr_reader :time, :player, :position

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} position_report \(position "(?'position'[^"]+)"\)/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section position]
      end

      def initialize(time, name, uid, steam_id, team, position)
        @time = parse_time(time)
        @player = Player.new(name, uid, steam_id, team)
        @position = position
      end
    end
  end
end
