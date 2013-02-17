module TF2LineParser
  module Events

    class Heal

      attr_accessor :healer, :healer_team, :target, :target_team, :value

      def initialize(healer, healer_team, target, target_team, value)
        @healer = healer
        @healer_team = healer_team
        @target = target
        @target_team = target_team
        @value = value.to_i
      end
    end

  end
end
