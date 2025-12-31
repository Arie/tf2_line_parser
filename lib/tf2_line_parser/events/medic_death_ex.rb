module TF2LineParser
  module Events
    class MedicDeathEx < Event
      attr_reader :time, :player, :ubercharge

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "medic_death_ex" #{regex_uberpct}/.freeze
      end

      def self.regex_uberpct
        @regex_uberpct ||= '\(uberpct "(?\'uberpct\'\d+)"\)'
      end

      def self.attributes
        @attributes ||= %i[time player_section uberpct]
      end

      def initialize(time, player_name, player_uid, player_steam_id, player_team, uberpct)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @ubercharge = uberpct.to_i
      end
    end
  end
end
