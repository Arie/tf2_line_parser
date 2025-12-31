module TF2LineParser
  module Events
    class ChargeEnded < Event
      attr_reader :time, :player, :duration

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "chargeended" #{regex_duration}/.freeze
      end

      def self.regex_duration
        @regex_duration ||= '\(duration "(?\'duration\'[0-9.]+)"\)'
      end

      def self.attributes
        @attributes ||= %i[time player_section duration]
      end

      def initialize(time, name, uid, steam_id, team, duration)
        @time = parse_time(time)
        @player = Player.new(name, uid, steam_id, team)
        @duration = duration.to_f
      end
    end
  end
end
