module TF2LineParser
  module Events

    class Damage

      attr_accessor :team, :player, :value

      def initialize(team, player, value)
        @team = team
        @player = player
        @value = value.to_i
      end

    end
  end
end
