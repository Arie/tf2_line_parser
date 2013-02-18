module TF2LineParser
  module Events

    class Domination < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "domination" against #{regex_target}.*/
      end

      def self.attributes
        @attributes ||= [:time, :player_steamid, :player_team, :target_steamid, :target_team]
      end

      attr_accessor :time, :dominator, :dominator_team, :target, :target_team

      def initialize(time, dominator, dominator_team, target, target_team)
        @time = parse_time(time)
        @dominator = dominator
        @dominator_team = dominator_team
        @target = target
        @target_team = target
      end

    end
  end
end
