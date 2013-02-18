module TF2LineParser
  module Events

    class Assist < Event

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "kill assist" against #{regex_target}/
      end

      def self.attributes
        @attributes ||= [:time, :player_steamid, :player_team, :target_steamid, :target_team]
      end

      attr_accessor :time, :assistant, :assistant_team, :target, :target_team

      def initialize(time, assistant, assistant_team, target, target_team)
        @time = parse_time(time)
        @assistant = assistant
        @assistant_team = assistant_team
        @target = target
        @target_team = target_team
      end

    end

  end
end
