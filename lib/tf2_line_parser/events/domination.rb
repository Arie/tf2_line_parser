module TF2LineParser
  module Events

    class Domination < PVPEvent

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "domination" against #{regex_target}.*/
      end

    end
  end
end
