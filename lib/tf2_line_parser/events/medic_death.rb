module TF2LineParser
  module Events

    class MedicDeath < PVPEvent

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "medic_death" against #{regex_target}.*/
      end

    end
  end
end
