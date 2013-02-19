module TF2LineParser
  module Events

    class Assist < PVPEvent

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "kill assist" against #{regex_target}/
      end

    end

  end
end
