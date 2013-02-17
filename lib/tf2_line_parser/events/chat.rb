module TF2LineParser
  module Events


    class Chat

      attr_accessor :player, :team, :message

      def initialize(player, team, message)
        @player = player
        @team = team
        @message = message
      end
    end

    class Say < Chat; end
    class TeamSay < Chat; end

  end
end
