# frozen_string_literal: true

module TF2LineParser
  module Events
    class PointCapture < Event
      CAPPERS_REGEX = /\(player\d+\s+"(?<player_section>[^"]*<[^>]*><[^>]*><[^>]*>)"\)/

      attr_reader :cappers

      def self.regex
        @regex ||= /#{regex_time} Team "(?'team'Red|Blue)" triggered "pointcaptured" \(cp "(?'cp_number'\d+)"\) \(cpname "(?'cp_name'[^"]*)"\) \(numcappers "(?'numcappers'\d+)"\)(?'cappers_section'.*)/.freeze
      end

      def self.attributes
        @attributes ||= %i[time team cp_number cp_name numcappers cappers_section]
      end

      def initialize(time, team, cap_number, cap_name, _numcappers, cappers_section)
        @time = parse_time(time)
        @team = team
        @cap_number = cap_number
        @cap_name = cap_name
        @cappers = parse_cappers(cappers_section)
      end

      private

      def parse_cappers(section)
        return [] unless section

        section.scan(CAPPERS_REGEX).map do |match|
          name, uid, steam_id, team = self.class.parse_player_section(match[0])
          Player.new(name, uid, steam_id, team) if name
        end.compact
      end
    end
  end
end
