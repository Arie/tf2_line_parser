module TF2LineParser
  module Events

    class MedicDeath < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "medic_death" against #{regex_target}.*/
      end

      def self.attributes
        @attributes ||= [:time, :player_nick, :player_steamid, :player_team, :target_nick, :target_steamid, :target_team]
      end

      attr_accessor :time, :player, :medic

      def initialize(time, medic_killer_name, medic_killer_steam_id, medic_killer_team, medic_name, medic_steam_id, medic_team)
        @time = parse_time(time)
        @player = Player.new(medic_killer_name, medic_killer_steam_id, medic_killer_team)
        @medic = Player.new(medic_name, medic_steam_id, medic_team)
      end

    end
  end
end
