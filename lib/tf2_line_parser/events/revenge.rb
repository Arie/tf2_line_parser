module TF2LineParser
  module Events

    class Revenge < PVPEvent

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "revenge" against #{regex_target}.*/
      end

    end
  end
end
