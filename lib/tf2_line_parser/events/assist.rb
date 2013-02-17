module TF2LineParser
  module Events

    class Assist

      attr_accessor :assistant, :assistant_team, :target, :target_team

      def initialize(assistant, assistant_team, target, target_team)
        @assistant = assistant
        @assistant_team = assistant_team
        @target = target
        @target_team = target_team
      end
    end

  end
end
