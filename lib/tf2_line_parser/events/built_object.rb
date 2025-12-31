module TF2LineParser
  module Events
    class BuiltObject < Event
      attr_reader :time, :player, :object

      def self.regex
        @regex ||= /#{regex_time} #{regex_player} triggered "(?:player_)?builtobject" #{regex_object_info}#{regex_position}?/.freeze
      end

      def self.regex_object_info
        @regex_object_info ||= '\(object "(?\'object\'[^"]+)"\)'
      end

      def self.regex_position
        @regex_position ||= / \(position "[^"]+"\)/
      end

      def self.attributes
        @attributes ||= %i[time player_section object]
      end

      def initialize(time, name, uid, steam_id, team, object)
        @time = parse_time(time)
        @player = Player.new(name, uid, steam_id, team)
        @object = object
      end
    end
  end
end
