module TF2LineParser

  class Line

    REGEX_TIME = 'L (?\'time\'.*):.*'
    REGEX_PLAYER = '"(?\'player_nick\'.+)<(?\'player_uid\'\d+)><(?\'player_steamid\'STEAM_\S+)><(?\'player_team\'Red|Blue)>"'
    REGEX_TARGET = '"(?\'target_nick\'.+)<(?\'target_uid\'\d+)><(?\'target_steamid\'STEAM_\S+)><(?\'target_team\'Red|Blue)>"'
    REGEX_CONSOLE = '"Console<0><Console><Console>"'
    REGEX_MESSAGE = '"(?\'message\'.*)"'
    REGEX_ROUND_START = /#{REGEX_TIME} World triggered "Round_Start"/
    REGEX_ROUND_END_WIN = /#{REGEX_TIME} World triggered "Round_Win" \(winner "(?'team'Red|Blue)"\)/
    REGEX_ROUND_END_STALEMATE = /#{REGEX_TIME} World triggered "Round_Stalemate"/
    REGEX_MATCH_END = /#{REGEX_TIME} World triggered "Game_Over" reason "(?'reason'.*)"/
    REGEX_DAMAGE = /#{REGEX_TIME} #{REGEX_PLAYER} triggered "damage" \(damage "(?'value'\d+)"\)/
    REGEX_HEAL = /#{REGEX_TIME} #{REGEX_PLAYER} triggered "healed" against #{REGEX_TARGET} \(healing "(?'value'\d+)"\)/
    REGEX_KILL = /#{REGEX_TIME} #{REGEX_PLAYER} killed #{REGEX_TARGET} with/
    REGEX_ASSIST = /#{REGEX_TIME} #{REGEX_PLAYER} triggered "kill assist" against #{REGEX_TARGET}/
    REGEX_CAPTURE = /#{REGEX_TIME} Team "(?'team'Red|Blue)" triggered "pointcaptured" \(cp "(?'cp_number'\d+)"\) \(cpname "(?'cp_name'.*)"\) \(numcappers/
    REGEX_SAY = /#{REGEX_TIME} #{REGEX_PLAYER} say #{REGEX_MESSAGE}/
    REGEX_TEAM_SAY = /#{REGEX_TIME} #{REGEX_PLAYER} say_team #{REGEX_MESSAGE}/
    REGEX_CONSOLE_SAY = /#{REGEX_TIME} #{REGEX_CONSOLE} say #{REGEX_MESSAGE}/
    TIME_FORMAT = '%m/%d/%Y - %T'

    def self.types_without_regex_groups
      [:round_start, :round_end_stalemate]
    end

    def self.types_with_regex_groups
      [:round_end_win, :match_end, :capture, :damage, :heal, :kill, :assist, :say, :team_say, :console_say]
    end

    def self.types
      self.types_without_regex_groups + self.types_with_regex_groups
    end

    attr_accessor :line

    def initialize(line)
      @line = line.force_encoding('UTF-8').encode('UTF-16LE', :invalid => :replace, :replace => '').encode('UTF-8')
    end

    def matches
      Line.types.each do |type|
        if send(type)
          @match ||= [type, send(type)]
          break
        end
      end
      @match
    end

    Line.types_without_regex_groups.each do |type|
      define_method(type) { line.match(Line.const_get("REGEX_#{type.upcase}")) }
    end

    Line.types_with_regex_groups.each do |type|
      define_method(type) { regex_results(line.match(Line.const_get("REGEX_#{type.upcase}")), send("#{type}_attributes")) }
    end

    def time
      if result = line.match(REGEX_TIME)
        Time.strptime(result[:time], TIME_FORMAT)
      end
    end

    private

    def damage_attributes
      [:player_steamid, :player_team, :value]
    end

    def kill_attributes
      [:player_steamid, :player_team, :target_steamid, :target_team]
    end

    def heal_attributes
      [:player_steamid, :player_team, :target_steamid, :target_team, :value]
    end

    def capture_attributes
      [:team, :cp_number, :cp_name]
    end

    def assist_attributes
      [:player_steamid, :player_team, :target_steamid, :target_team]
    end

    def chat_attributes
      [:player_steamid, :player_team, :message]
    end
    alias_method :say_attributes,      :chat_attributes
    alias_method :team_say_attributes, :chat_attributes

    def console_say_attributes
      [:message]
    end

    def round_end_win_attributes
      [:team]
    end

    def match_end_attributes
      [:reason]
    end

    def regex_results(matched_line = nil, attributes)
      if matched_line
        attributes.collect do |attribute|
          matched_line[attribute]
        end
      end
    end

  end

end
