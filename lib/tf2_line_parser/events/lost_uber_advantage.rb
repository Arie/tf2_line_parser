module TF2LineParser
  module Events
    class LostUberAdvantage < Event
      attr_reader :time, :player, :advantage_time

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "lost_uber_advantage" #{regex_advantage_time}/.freeze
      end

      def self.regex_advantage_time
        @regex_advantage_time ||= '\(time "(?\'advantage_time\'[0-9.]+)"\)'
      end

      def self.attributes
        @attributes ||= %i[time player_section advantage_time]
      end

      def initialize(time, name, uid, steam_id, team, advantage_time)
        @time = parse_time(time)
        @player = Player.new(name, uid, steam_id, team)
        @advantage_time = advantage_time.to_f
      end
    end
  end
end
