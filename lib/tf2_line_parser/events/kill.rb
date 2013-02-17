module TF2LineParser
  module Events

    class Kill

      attr_accessor :killer, :killer_team, :target, :target_team

      def initialize(killer, killer_team, target, target_team)
        @killer = killer
        @killer_team = killer_team
        @target = target
        @target_team = target_team
      end
    end

  end
end
