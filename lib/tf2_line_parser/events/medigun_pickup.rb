# frozen_string_literal: true

module TF2LineParser
  module Events
    class MedigunPickup < Event
      attr_reader :time, :player, :medigun, :ubercharge, :previous_medigun, :previous_ubercharge

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "medigun_pickup" \(medigun "(?'medigun'[^"]*)"\) \(uberpct "(?'uberpct'\d+)"\) \(previous_medigun "(?'previous_medigun'[^"]*)"\) \(previous_uberpct "(?'previous_uberpct'\d+)"\)/
      end

      def self.attributes
        @attributes ||= %i[time player_section medigun uberpct previous_medigun previous_uberpct]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, medigun, uberpct, previous_medigun, previous_uberpct)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @medigun = medigun
        @ubercharge = uberpct.to_i
        @previous_medigun = previous_medigun
        @previous_ubercharge = previous_uberpct.to_i
      end
    end
  end
end
