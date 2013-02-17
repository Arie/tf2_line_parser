module TF2LineParser
  class Parser

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

    attr_accessor :line, :time, :event

    def initialize(line)
      @line = line.force_encoding('UTF-8').encode('UTF-16LE', :invalid => :replace, :replace => '').encode('UTF-8')
      @time = parse_time(@line)
    end

    def parsed_event
      parse
    end

    def parse
      if res = line.match(REGEX_ROUND_START)
        process_round_start
      elsif res = line.match(REGEX_ROUND_END_WIN)
        process_round_end_win res[:team]
      elsif res = line.match(REGEX_ROUND_END_STALEMATE)
        process_round_end_stalemate
      elsif res = line.match(REGEX_MATCH_END)
        process_match_end res[:reason]
      elsif res = line.match(REGEX_CAPTURE)
        process_capture res[:team], res[:cp_number], res[:cp_name]
      elsif res = line.match(REGEX_DAMAGE)
        process_damage res[:player_steamid], res[:player_team], res[:value]
      elsif res = line.match(REGEX_HEAL)
        process_heal res[:player_steamid], res[:player_team], res[:target_steamid], res[:target_team], res[:value]
      elsif res = line.match(REGEX_KILL)
        process_kill res[:player_steamid], res[:player_team], res[:target_steamid], res[:target_team]
      elsif res = line.match(REGEX_ASSIST)
        process_assist res[:player_steamid], res[:player_team], res[:target_steamid], res[:target_team]
      elsif res = line.match(REGEX_CHAT_SAY)
        process_say res[:player_steamid], res[:player_team], res[:message]
      elsif res = line.match(REGEX_CHAT_TEAM_SAY)
        process_team_say res[:player_steamid], res[:player_team], res[:message]
      end
    end

    def process_round_start
      Events::RoundStart.new
    end

    def process_round_end_win(winning_team)
      Events::RoundWin.new(winning_team)
    end

    def process_round_end_stalemate
      Events::RoundStalemate.new
    end

    def process_match_end(reason)
      Events::MatchEnd.new(reason)
    end

    def process_capture(team, cap_number, cap_name)
      Events::PointCapture.new(team, cap_number, cap_name)
    end

    def process_damage(player, team, value)
      Events::Damage.new(player, team, value)
    end

    def process_heal(healer, healer_team, target, target_team, value)
      Events::Heal.new(healer, healer_team, target, target_team, value)
    end

    def process_kill(killer, killer_team, target, target_team)
      Events::Kill.new(killer, killer_team, target, target_team)
    end

    def process_assist(assistant, assistant_team, target, target_team)
      Events::Assist.new(assistant, assistant_team, target, target_team)
    end

    def process_say(player, team, message)
      Events::Say.new(player, team, message)
    end

    def process_team_say(player, team, message)
      Events::TeamSay.new(player, team, message)
    end

    private

    def parse_time(line)
      if result = line.match(REGEX_TIME)
        DateTime.strptime(result[:time], TIME_FORMAT).to_time
      end
    end

  end
end
