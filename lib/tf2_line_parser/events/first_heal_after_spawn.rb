module TF2LineParser
  module Events
    class FirstHealAfterSpawn < Event
      attr_reader :time, :player, :heal_time

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "first_heal_after_spawn" #{regex_heal_time}/.freeze
      end

      def self.regex_heal_time
        @regex_heal_time ||= '\(time "(?\'heal_time\'[0-9.]+)"\)'
      end

      def self.attributes
        @attributes ||= %i[time player_section heal_time]
      end

      def initialize(time, name, uid, steam_id, team, heal_time)
        @time = parse_time(time)
        @player = Player.new(name, uid, steam_id, team)
        @heal_time = heal_time.to_f
      end
    end
  end
end
