module TF2LineParser
  class Parser

    attr_accessor :line, :time, :event

    def initialize(line)
      @line = Line.new(line)
      @time = @line.time
    end

    def parse
      if line_type_and_match_result
        send("process_#{line_type}", *line_match_result)
      end
    end

    def process_round_start(*line_match_result)
      Events::RoundStart.new
    end

    def process_round_end_win(winning_team)
      Events::RoundWin.new(winning_team)
    end

    def process_round_end_stalemate(*line_match_result)
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

    def process_console_say(message)
      Events::ConsoleSay.new(message)
    end

    private

    def line_type_and_match_result
      line.matches
    end

    def line_type
      line_type_and_match_result[0]
    end

    def line_match_result
      line_type_and_match_result[1]
    end

  end
end
