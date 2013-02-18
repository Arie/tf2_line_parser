require 'spec_helper'


module TF2LineParser

  describe Parser do

    let(:log_file)   { File.expand_path('../../../fixtures/logs/broder_vs_epsilon.log',  __FILE__) }
    let(:log)        { File.read(log_file) }
    let(:log_lines)  { log.lines.map(&:to_s) }

    describe '#new' do

      it 'takes the log line and gets the date from it' do
        Parser.new(log_lines.first).parse.time.should eql Time.local(2013, 2, 7, 21, 21, 8)
      end

    end

    describe '#parse' do

      def parse(line)
        Parser.new(line).parse
      end

      it 'recognizes damage' do
        line = log_lines[1001]
        team = "STEAM_0:1:16347045"
        player = 'Red'
        value = '69'
        Events::Damage.should_receive(:new).with(anything, team, player, value)
        parse(line)
      end

      it 'recognizes a round start' do
        line = log_lines[1245]
        Events::RoundStart.should_receive(:new)
        parse(line)
      end

      it 'recognizes a point capture' do
        line = log_lines[1360]
        team = 'Blue'
        cap_number = '2'
        cap_name = '#Badlands_cap_cp3'
        Events::PointCapture.should_receive(:new).with(anything, team, cap_number, cap_name)
        parse(line)
      end

      it 'recognizes a round win' do
        line = log_lines[1439]
        winner = "Blue"
        Events::RoundWin.should_receive(:new).with(anything, winner)
        parse(line)
      end

      it 'recognizes a stalemate round' do
        line = 'L 02/07/2013 - 21:34:05: World triggered "Round_Stalemate"'
        Events::RoundStalemate.should_receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes a match end' do
        line = log_lines[4169]
        reason = "Reached Win Difference Limit"
        Events::MatchEnd.should_receive(:new).with(anything, reason)
        parse(line)
      end

      it 'recognizes a heal' do
        line = log_lines[1433]
        healer = 'STEAM_0:1:12124893'
        healer_team = 'Red'
        target = 'STEAM_0:1:16347045'
        target_team = 'Red'
        value = '1'
        Events::Heal.should_receive(:new).with(anything, healer, healer_team, target, target_team, value)
        parse(line)
      end

      it 'recognizes an assist' do
        line = log_lines[1451]
        assistant = "STEAM_0:1:13978585"
        assistant_team = 'Blue'
        target = "STEAM_0:0:16858056"
        target_team = 'Red'
        Events::Assist.should_receive(:new).with(anything, assistant, assistant_team, target, target_team)
        parse(line)
      end

      it 'recognizes chat' do
        line = log_lines[89]
        player =  "STEAM_0:1:12124893"
        team = 'Red'
        message = "it's right for the ping"
        Events::Say.should_receive(:new).with(anything, player, team, message)
        parse(line)
      end

      it 'recognizes team chat' do
        line = log_lines[303]
        player = "STEAM_0:1:18504112"
        team = 'Blue'
        message = ">>> USING UBER <<<[info] "
        Events::TeamSay.should_receive(:new).with(anything, player, team, message)
        parse(line)
      end

      it 'recognizes console say' do
        line = log_lines[1]
        message = "ETF2L config (2012-09-28) loaded."
        Events::ConsoleSay.should_receive(:new).with(anything, message)
        parse(line)
      end

      it 'recognizes current score' do
        line = log_lines[1442]
        team = "Blue"
        score = "1"
        Events::CurrentScore.should_receive(:new).with(anything, team, score)
        parse(line)
      end

      it 'deals with unknown lines' do
        line = log_lines[0]
        time = "02/07/2013 - 21:21:08"
        unknown = 'Log file started (file "logs/L0207006.log") (game "/home/hz00112/tf2/orangebox/tf") (version "5198")'
        Events::Unknown.should_receive(:new).with(time, unknown)
        parse(line)
      end


      it 'can parse all lines in the example log files without exploding' do
        broder_vs_epsilon   = File.expand_path('../../../fixtures/logs/broder_vs_epsilon.log',  __FILE__)
        special_characters  = File.expand_path('../../../fixtures/logs/special_characters.log',  __FILE__)
        ntraum_example      = File.expand_path('../../../fixtures/logs/example.log',  __FILE__)
        log_files = [broder_vs_epsilon, special_characters, ntraum_example]

        log_files.each do |log_file|
          log = File.read(log_file)
          expect {
            log.lines.map(&:to_s).each do |line|
              parse(line)
            end
          }.to_not raise_error
        end
      end


    end

  end
end
