module TF2LineParser

  class Line

    REGEX_TIME = 'L (?\'time\'.*):.*'
    REGEX_PLAYER = '"(?\'player_nick\'.+)<(?\'player_uid\'\d+)><(?\'player_steamid\'STEAM_\S+)><(?\'player_team\'Red|Blue)>"'
    REGEX_TARGET = '"(?\'target_nick\'.+)<(?\'target_uid\'\d+)><(?\'target_steamid\'STEAM_\S+)><(?\'target_team\'Red|Blue)>"'
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
    REGEX_CHAT_SAY = /#{REGEX_TIME} #{REGEX_PLAYER} say #{REGEX_MESSAGE}/
    REGEX_CHAT_TEAM_SAY = /#{REGEX_TIME} #{REGEX_PLAYER} say_team #{REGEX_MESSAGE}/

    TIME_FORMAT = '%m/%d/%Y - %T'

    attr_accessor :line

    def initialize(line)
      @line = line.force_encoding('UTF-8').encode('UTF-16LE', :invalid => :replace, :replace => '').encode('UTF-8')
    end

    def matches
      line_types.each do |type|
        if send(type)
          @match ||= [type, send(type)]
          break
        end
      end
      @match
    end

    def round_start
      @round_start ||= line.match(REGEX_ROUND_START)
    end

    def round_end_win
      @round_end_win ||= line.match(REGEX_ROUND_END_WIN)
      @round_end_win[:team] if @round_end_win
    end

    def round_end_stalemate
      @round_end_stalemate ||= line.match(REGEX_ROUND_END_STALEMATE)
    end

    def match_end
      @match_end ||= line.match(REGEX_MATCH_END)
      @match_end[:reason] if @match_end
    end

    def capture
      @capture ||= line.match(REGEX_CAPTURE)
      [@capture[:team], @capture[:cp_number], @capture[:cp_name]] if @capture
    end

    def damage
      @damage ||= line.match(REGEX_DAMAGE)
      [@damage[:player_steamid], @damage[:player_team], @damage[:value]] if @damage
    end

    def heal
      @heal ||= line.match(REGEX_HEAL)
      [@heal[:player_steamid], @heal[:player_team], @heal[:target_steamid], @heal[:target_team], @heal[:value]] if @heal
    end

    def kill
      @kill ||= line.match(REGEX_KILL)
      [@kill[:player_steamid], @kill[:player_team], @kill[:target_steamid], @kill[:target_team]] if @kill
    end

    def assist
      @assist ||= line.match(REGEX_ASSIST)
      [@assist[:player_steamid], @assist[:player_team], @assist[:target_steamid], @assist[:target_team]] if @assist
    end

    def say
      @say ||= line.match(REGEX_CHAT_SAY)
      [@say[:player_steamid], @say[:player_team], @say[:message]] if @say
    end

    def team_say
      @team_say ||= line.match(REGEX_CHAT_TEAM_SAY)
      [@team_say[:player_steamid], @team_say[:player_team], @team_say[:message]] if @team_say
    end

    def time
      if result = line.match(REGEX_TIME)
        DateTime.strptime(result[:time], TIME_FORMAT).to_time
      end
    end

    private

    def line_types
      [:round_start, :round_end_win, :round_end_stalemate, :match_end, :capture, :damage, :heal, :kill, :assist, :say, :team_say]
    end

  end

end
