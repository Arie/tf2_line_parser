module TF2LineParser
  module Events

    class Revenge < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "revenge" against #{regex_target}.*/
      end

      def self.attributes
        @attributes ||= [:time, :player_steamid, :player_team, :target_steamid, :target_team]
      end

      attr_accessor :time, :avenger, :avenger_team, :target, :target_team

      def initialize(time, avenger, avenger_team, target, target_team)
        @time = parse_time(time)
        @avenger = avenger
        @avenger_team = avenger_team
        @target = target
        @target_team = target
      end

    end
  end
end
