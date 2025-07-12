# frozen_string_literal: true

module TF2LineParser
  module Events
    class Chat < Event
      def initialize(time, player_name, player_uid, player_steam_id, player_team, message)
        @time = parse_time(time)
        @player = Player.new(player_name, player_uid, player_steam_id, player_team)
        @message = message
      end

      def self.attributes
        @attributes ||= %i[time player_section message]
      end

      def self.regex_results(matched_line)
        time = matched_line['time']
        player_section = matched_line['player_section']
        message = matched_line['message']

        # Parse player section
        player_name, player_uid, player_steamid, player_team = parse_player_section(player_section)

        [time, player_name, player_uid, player_steamid, player_team, message]
      end
    end

    class Say < Chat
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} say #{regex_message}/.freeze
      end
    end

    class TeamSay < Chat
      def self.regex
        @regex ||= /#{regex_time} #{regex_player} say_team #{regex_message}/.freeze
      end
    end
  end
end
