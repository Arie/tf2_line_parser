module TF2LineParser
  module Events
    class ChargeReady < Event
      attr_reader :time, :player

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "chargeready"/.freeze
      end

      def self.attributes
        @attributes ||= %i[time player_section]
      end

      def initialize(time, name, uid, steam_id, team)
        @time = parse_time(time)
        @player = Player.new(name, uid, steam_id, team)
      end
    end
  end
end
