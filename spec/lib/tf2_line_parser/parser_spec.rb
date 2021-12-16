# frozen_string_literal: true

require 'spec_helper'

module TF2LineParser
  describe Parser do
    let(:log_file)   { File.expand_path('../../fixtures/logs/broder_vs_epsilon.log', __dir__) }
    let(:log)        { File.read(log_file) }
    let(:log_lines)  { log.lines.map(&:to_s) }
    let(:detailed_log_file)   { File.expand_path('../../fixtures/logs/detailed_damage.log', __dir__) }
    let(:detailed_log)        { File.read(detailed_log_file) }
    let(:detailed_log_lines)  { detailed_log.lines.map(&:to_s) }
    let(:airshot_log_file)    { File.expand_path('../../fixtures/logs/airshot.log', __dir__) }
    let(:airshot_log)         { File.read(airshot_log_file) }
    let(:airshot_log_lines)   { airshot_log.lines.map(&:to_s) }
    let(:new_log_file)    { File.expand_path('../../fixtures/logs/new_log.log', __dir__) }
    let(:new_log)         { File.read(new_log_file) }
    let(:new_log_lines)   { new_log.lines.map(&:to_s) }
    let(:csgo_log_file)   { File.expand_path('../../fixtures/logs/csgo.log', __dir__) }
    let(:csgo_log)        { File.read(csgo_log_file) }
    let(:csgo_log_lines)  { csgo_log.lines.map(&:to_s) }

    describe '#new' do
      it 'takes the log line and gets the date from it' do
        expect(Parser.new(log_lines.first).parse.time).to eql Time.local(2013, 2, 7, 21, 21, 8)
      end
    end

    describe '#parse' do
      def parse(line)
        Parser.new(line).parse
      end

      it 'recognizes damage' do
        line = log_lines[1001]
        player_name = 'Epsilon numlocked'
        player_steam_id = 'STEAM_0:1:16347045'
        player_team = 'Red'
        value = '69'
        weapon = nil
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_steam_id, player_team, nil, nil,
                                                     nil, value, weapon)
        parse(line)
      end

      it 'recognizes new steam id log lines with detailed damage' do
        line = new_log_lines[0]
        player_name = 'iM yUKi intel @i52'
        player_steam_id = '[U:1:3825470]'
        player_team = 'Blue'
        target_team = 'Red'
        target_name = 'mix^ enigma @ i52'
        target_steam_id = '[U:1:33652944]'
        value = '78'
        weapon = 'tf_projectile_rocket'
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_steam_id, player_team, target_name,
                                                     target_steam_id, target_team, value, weapon)
        parse(line)
      end

      it 'recognizes detailed damage' do
        line = detailed_log_lines[61]
        player_name = 'LittleLies'
        player_steam_id = 'STEAM_0:0:55031498'
        player_team = 'Blue'
        target_name = 'Aquila'
        target_steam_id = 'STEAM_0:0:43087158'
        target_team = 'Red'
        value = '102'
        weapon = 'tf_projectile_pipe'
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_steam_id, player_team, target_name,
                                                     target_steam_id, target_team, value, weapon)
        parse(line)
      end

      it 'recognizes airshots' do
        line = airshot_log_lines[0]
        weapon = 'tf_projectile_rocket'
        airshot = '1'
        expect(Events::Airshot).to receive(:new).with(anything, anything, anything, anything, anything, anything,
                                                      anything, anything, weapon, airshot)
        parse(line).inspect
      end

      it 'recognizes sniper headshot damage' do
        line = detailed_log_lines[3645]
        weapon = 'sniperrifle'
        expect(Events::HeadshotDamage).to receive(:new).with(anything, anything, anything, anything, anything,
                                                             anything, anything, anything, weapon)
        parse(line).inspect
      end

      it 'ignores realdamage' do
        line = detailed_log_lines[65]
        player_name = 'LittleLies'
        player_steam_id = 'STEAM_0:0:55031498'
        player_team = 'Blue'
        target_name = 'Aquila'
        target_steam_id = 'STEAM_0:0:43087158'
        target_team = 'Red'
        value = '98'
        weapon = 'tf_projectile_pipe'
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_steam_id, player_team, target_name,
                                                     target_steam_id, target_team, value, weapon)
        parse(line)
      end

      it 'recognizes a round start' do
        line = log_lines[1245]
        expect(Events::RoundStart).to receive(:new)
        parse(line)
      end

      it 'recognizes a point capture' do
        line = log_lines[1360]
        team = 'Blue'
        cap_number = '2'
        cap_name = '#Badlands_cap_cp3'
        expect(Events::PointCapture).to receive(:new).with(anything, team, cap_number, cap_name)
        parse(line)
      end

      it 'recognizes a round win' do
        line = log_lines[1439]
        winner = 'Blue'
        expect(Events::RoundWin).to receive(:new).with(anything, winner)
        parse(line)
      end

      it 'recognizes a stalemate round' do
        line = 'L 02/07/2013 - 21:34:05: World triggered "Round_Stalemate"'
        expect(Events::RoundStalemate).to receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes a match end' do
        line = log_lines[4169]
        reason = 'Reached Win Difference Limit'
        expect(Events::MatchEnd).to receive(:new).with(anything, reason)
        parse(line)
      end

      it 'recognizes a heal' do
        line = log_lines[1433]
        player_name = 'Epsilon KnOxXx'
        player_steam_id = 'STEAM_0:1:12124893'
        player_team = 'Red'
        target_name = 'Epsilon numlocked'
        target_steam_id = 'STEAM_0:1:16347045'
        target_team = 'Red'
        value = '1'
        expect(Events::Heal).to receive(:new).with(anything, player_name, player_steam_id, player_team, target_name,
                                                   target_steam_id, target_team, value)
        parse(line)
      end

      it 'recognizes a kill' do
        line = log_lines[1761]
        player_name = 'Epsilon basH.'
        player_steam_id = 'STEAM_0:1:15829615'
        player_team = 'Red'
        target_name = 'broder jukebox'
        target_steam_id = 'STEAM_0:1:13978585'
        target_team = 'Blue'
        weapon = 'pistol_scout'
        customkill = nil
        expect(Events::Kill).to receive(:new).with(anything, player_name, player_steam_id, player_team, target_name,
                                                   target_steam_id, target_team, weapon, customkill)
        parse(line)
      end

      it 'recognizes headshot kills' do
        line = log_lines[1951]
        weapon = 'sniperrifle'
        customkill = 'headshot'
        expect(Events::Kill).to receive(:new).with(anything, anything, anything, anything, anything, anything,
                                                   anything, weapon, customkill)
        parse(line)
      end

      it 'recognizes an assist' do
        line = log_lines[1451]
        player_name = 'broder jukebox'
        player_steam_id = 'STEAM_0:1:13978585'
        player_team = 'Blue'
        target_name = 'Epsilon Mitsy'
        target_steam_id = 'STEAM_0:0:16858056'
        target_team = 'Red'
        expect(Events::Assist).to receive(:new).with(anything, player_name, player_steam_id, player_team, target_name,
                                                     target_steam_id, target_team)
        parse(line)
      end

      it 'recognizes connect' do
        line = log_lines[9]
        name = 'Epsilon numlocked'
        steam_id = 'STEAM_0:1:16347045'
        team = ''
        message = '0.0.0.0:27005'
        expect(Events::Connect).to receive(:new).with(anything, name, steam_id, team, message)
        parse(line)
      end

      it 'recognizes disconnect' do
        line = log_lines[4542]
        name = 'cc//TviQ'
        steam_id = 'STEAM_0:0:8520477'
        team = 'Blue'
        message = 'Disconnect by user.'
        expect(Events::Disconnect).to receive(:new).with(anything, name, steam_id, team, message)
        parse(line)
      end

      it 'recognizes chat' do
        line = log_lines[89]
        name = 'Epsilon KnOxXx'
        steam_id = 'STEAM_0:1:12124893'
        team = 'Red'
        message = "it's right for the ping"
        expect(Events::Say).to receive(:new).with(anything, name, steam_id, team, message)
        parse(line)
      end

      it 'recognizes team chat' do
        line = log_lines[303]
        name = 'broder mirelin'
        steam_id = 'STEAM_0:1:18504112'
        team = 'Blue'
        message = '>>> USING UBER <<<[info] '
        expect(Events::TeamSay).to receive(:new).with(anything, name, steam_id, team, message)
        parse(line)
      end

      it 'recognizes dominations' do
        line = log_lines[1948]
        name = 'Epsilon basH.'
        steam_id = 'STEAM_0:1:15829615'
        team = 'Red'
        target_name = 'broder jukebox'
        target_steam_id = 'STEAM_0:1:13978585'
        target_team = 'Blue'
        expect(Events::Domination).to receive(:new).with(anything, name, steam_id, team, target_name, target_steam_id,
                                                         target_team)
        parse(line)
      end

      it 'recognizes revenges' do
        line = log_lines[2354]
        name = 'broder jukebox'
        steam_id = 'STEAM_0:1:13978585'
        team = 'Blue'
        target_name = 'Epsilon basH.'
        target_steam_id = 'STEAM_0:1:15829615'
        target_team = 'Red'
        expect(Events::Revenge).to receive(:new).with(anything, name, steam_id, team, target_name, target_steam_id,
                                                      target_team)
        parse(line)
      end

      it 'recognizes current score' do
        line = log_lines[1442]
        team = 'Blue'
        score = '1'
        expect(Events::CurrentScore).to receive(:new).with(anything, team, score)
        parse(line)
      end

      it 'recognizes final score' do
        line = log_lines[4170]
        team = 'Red'
        score = '6'
        expect(Events::FinalScore).to receive(:new).with(anything, team, score)
        parse(line)
      end

      it 'recognizes item pickup' do
        line = log_lines[51]
        name = 'Epsilon Mike'
        steam_id = 'STEAM_0:1:1895232'
        team = 'Blue'
        item = 'medkit_medium'
        expect(Events::PickupItem).to receive(:new).with(anything, name, steam_id, team, item)
        parse(line)
      end

      it 'recognizes stalemate round' do
        line = 'L 02/07/2013 - 21:21:08: World triggered "Round_Stalemate"'
        expect(Events::RoundStalemate).to receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes ubercharges' do
        line = log_lines[1416]
        name = 'broder mirelin'
        steam_id = 'STEAM_0:1:18504112'
        team = 'Blue'
        expect(Events::ChargeDeployed).to receive(:new).with(anything, name, steam_id, team)
        parse(line)

        line = detailed_log_lines[782]
        name = 'flo ❤'
        steam_id = 'STEAM_0:1:53945481'
        team = 'Blue'
        expect(Events::ChargeDeployed).to receive(:new).with(anything, name, steam_id, team)
        parse(line)
      end

      it 'recognizes medic deaths' do
        line = log_lines[1700]
        medic_name = 'broder mirelin'
        medic_steam_id = 'STEAM_0:1:18504112'
        medic_team = 'Blue'
        killer_name = 'Epsilon numlocked'
        killer_steam_id = 'STEAM_0:1:16347045'
        killer_team = 'Red'
        healing = '1975'
        expect(Events::MedicDeath).to receive(:new).with(anything, killer_name, killer_steam_id, killer_team,
                                                         medic_name, medic_steam_id, medic_team, healing, '0')
        parse(line)
      end

      it 'recognizes medic uberdrops' do
        uberdrop = 'L 10/04/2012 - 21:43:06: "TLR Traxantic<28><STEAM_0:1:1328042><Red>" triggered "medic_death" against "cc//Admirable<3><STEAM_0:0:154182><Blue>" (healing "6478") (ubercharge "1")'
        expect(Events::MedicDeath).to receive(:new).with(anything, anything, anything, anything, anything, anything,
                                                         anything, anything, '1')
        parse(uberdrop)
      end

      it 'recognizes medic healing on death' do
        line = 'L 10/04/2012 - 21:43:06: "TLR Traxantic<28><STEAM_0:1:1328042><Red>" triggered "medic_death" against "cc//Admirable<3><STEAM_0:0:154182><Blue>" (healing "6478") (ubercharge "1")'
        expect(Events::MedicDeath).to receive(:new).with(anything, anything, anything, anything, anything, anything,
                                                         anything, '6478', anything)
        parse(line)
      end

      it 'recognizes role changes' do
        line = log_lines[1712]
        player_name = 'broder bybben'
        player_steam_id = 'STEAM_0:1:159631'
        player_team = 'Blue'
        role = 'scout'
        expect(Events::RoleChange).to receive(:new).with(anything, player_name, player_steam_id, player_team, role)
        parse(line)
      end

      it 'recognizes round length' do
        line = log_lines[2275]
        length = '237.35'
        expect(Events::RoundLength).to receive(:new).with(anything, length)
        parse(line)
      end

      it 'recognizes capture block' do
        line = log_lines[3070]
        name = 'Epsilon basH.'
        steam_id = 'STEAM_0:1:15829615'
        team = 'Red'
        cap_number = '2'
        cap_name = '#Badlands_cap_cp3'
        expect(Events::CaptureBlock).to receive(:new).with(anything, name, steam_id, team, cap_number, cap_name)
        parse(line)
      end

      it 'recognizes suicides' do
        line = log_lines[76]
        name = '.schocky'
        steam_id = 'STEAM_0:0:2829363'
        team = 'Red'
        suicide_method = 'world'
        expect(Events::Suicide).to receive(:new).with(anything, name, steam_id, team, suicide_method)
        parse(line)
      end

      it 'recognizes spawns' do
        line = log_lines[4541]
        name = 'candyyou # Infinity Gaming'
        steam_id = 'STEAM_0:0:50979748'
        team = 'Red'
        klass = 'Soldier'
        expect(Events::Spawn).to receive(:new).with(anything, name, steam_id, team, klass)
        parse(line)
      end

      it 'deals with unknown lines' do
        line = log_lines[0]
        time = '02/07/2013 - 21:21:08'
        unknown = 'Log file started (file "logs/L0207006.log") (game "/home/hz00112/tf2/orangebox/tf") (version "5198")'
        expect(Events::Unknown).to receive(:new).with(time, unknown)
        parse(line)
      end

      it 'can parse all lines in the example log files without exploding' do
        broder_vs_epsilon         = File.expand_path('../../fixtures/logs/broder_vs_epsilon.log',        __dir__)
        special_characters        = File.expand_path('../../fixtures/logs/special_characters.log',       __dir__)
        very_special_characters   = File.expand_path('../../fixtures/logs/very_special_characters.log',  __dir__)
        ntraum_example            = File.expand_path('../../fixtures/logs/example.log',                  __dir__)
        detailed_damage           = File.expand_path('../../fixtures/logs/detailed_damage.log',          __dir__)
        log_files = [broder_vs_epsilon, special_characters, very_special_characters, ntraum_example, detailed_damage]

        log_files.each do |log_file|
          log = File.read(log_file)
          expect do
            log.lines.map(&:to_s).each do |line|
              parse(line)
            end
          end.to_not raise_error
        end
      end

      it 'recognizes cs:go chat' do
        line = csgo_log_lines[299]
        name = '• Ben •'
        steam_id = 'STEAM_1:0:160621749'
        team = 'TERRORIST'
        message = '!rcon changelevel de_dust2'
        expect(Events::Say).to receive(:new).with(anything, name, steam_id, team, message)
        parse(line)
      end

      it "doesn't fall for twiikuu's cheeky name" do
        player_name = 't<1><[U:1:123456]><Red>" say "'
        line = %(L 02/07/2013 - 21:22:08: "#{player_name}<5><[U:1:1337]><Red>" say "!who")

        name = 't<1><[U:1:123456]><Red>" say "'
        steam_id = '[U:1:1337]'
        team = 'Red'
        message = '!who'
        expect(Events::Say).to receive(:new).with(anything, name, steam_id, team, message)

        parse(line)
      end
    end
  end
end
