module TF2LineParser
  module Events

    class Kill < PVPEvent

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} killed #{regex_target} with/
      end

    end

  end
end
