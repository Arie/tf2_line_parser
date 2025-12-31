module TF2LineParser
  module Events
    class JoinedTeam < PlayerActionEvent
      def self.action_text
        @action_text ||= 'joined team'
      end

      def self.regex_action
        @regex_team ||= '\"(?\'team_name\'.*)\"'
      end

      def self.item
        :team_name
      end

      def self.attributes
        @attributes ||= %i[time player_section team_name]
      end
    end
  end
end
