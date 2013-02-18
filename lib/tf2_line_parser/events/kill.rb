module TF2LineParser
  module Events

    class Kill < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} killed #{regex_target} with/
      end

      def self.attributes
        @attributes ||= [:time, :player_steamid, :player_team, :target_steamid, :target_team]
      end

      attr_accessor :time, :killer, :killer_team, :target, :target_team

      def initialize(time, killer, killer_team, target, target_team)
        @time = parse_time(time)
        @killer = killer
        @killer_team = killer_team
        @target = target
        @target_team = target_team
      end
    end

  end
end
