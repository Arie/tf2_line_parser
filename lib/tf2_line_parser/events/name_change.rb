# frozen_string_literal: true

module TF2LineParser
  module Events
    class NameChange < Event
      attr_reader :time, :player, :new_name

      # The old name must end in a <uid><steamid><team> tag, so a name that merely
      # contains ' changed name to ' can't make another line look like a name change.
      def self.regex
        @regex ||= /#{regex_time} "(?<player_section>.*?<\d+><[^<>"]*><[^<>"]*>)" changed name to "(?'new_name'.*)"/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section new_name]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, new_name)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @new_name = new_name
      end
    end
  end
end
