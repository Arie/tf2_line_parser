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
        player_uid = '4'
        player_steam_id = 'STEAM_0:1:16347045'
        player_team = 'Red'
        value = '69'
        weapon = nil
        healing = nil
        crit = nil
        headshot = nil
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, nil, nil,
                                                     nil, nil, value, weapon, healing, crit, headshot)
        parse(line)
      end

      it 'recognizes new steam id log lines with detailed damage' do
        line = new_log_lines[0]
        player_name = 'iM yUKi intel @i52'
        player_uid = '6'
        player_steam_id = '[U:1:3825470]'
        player_team = 'Blue'
        target_name = 'mix^ enigma @ i52'
        target_uid = '8'
        target_steam_id = '[U:1:33652944]'
        target_team = 'Red'
        value = '78'
        weapon = 'tf_projectile_rocket'
        healing = nil
        crit = nil
        headshot = nil
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name,
                                                     target_uid, target_steam_id, target_team, value, weapon, healing, crit, headshot)
        parse(line)
      end

      it 'recognizes detailed damage' do
        line = detailed_log_lines[61]
        player_name = 'LittleLies'
        player_uid = '16'
        player_steam_id = 'STEAM_0:0:55031498'
        player_team = 'Blue'
        target_name = 'Aquila'
        target_uid = '15'
        target_steam_id = 'STEAM_0:0:43087158'
        target_team = 'Red'
        value = '102'
        weapon = 'tf_projectile_pipe'
        healing = nil
        crit = nil
        headshot = nil
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name,
                                                     target_uid, target_steam_id, target_team, value, weapon, healing, crit, headshot)
        parse(line)
      end

      it 'recognizes airshots' do
        line = airshot_log_lines[0]
        weapon = 'tf_projectile_rocket'
        airshot = '1'
        expect(Events::Airshot).to receive(:new).with(anything, anything, anything, anything, anything, anything, anything,
                                                      anything, anything, anything, weapon, airshot)
        parse(line).inspect
      end

      it 'recognizes airshots with realdamage and height' do
        line = airshot_log_lines[1]
        result = parse(line)
        expect(result).to be_a(Events::Airshot)
        expect(result.player.name).to eq('tantwo')
        expect(result.player.steam_id).to eq('[U:1:191375689]')
        expect(result.player.team).to eq('Blue')
        expect(result.target.name).to eq('ryftomania(big/guy)')
        expect(result.target.steam_id).to eq('[U:1:468872526]')
        expect(result.target.team).to eq('Red')
        expect(result.damage).to eq(105)
        expect(result.weapon).to eq('quake_rl')
        expect(result.airshot).to eq(true)
      end

      it 'recognizes airshots without realdamage' do
        line = airshot_log_lines[4]
        result = parse(line)
        expect(result).to be_a(Events::Airshot)
        expect(result.player.name).to eq('tantwo')
        expect(result.damage).to eq(105)
        expect(result.weapon).to eq('quake_rl')
        expect(result.airshot).to eq(true)
      end

      it 'recognizes airshot heals (Crusader Crossbow mid-air)' do
        line = airshot_log_lines[2]
        result = parse(line)
        expect(result).to be_a(Events::AirshotHeal)
        expect(result.player.name).to eq('merkules')
        expect(result.player.steam_id).to eq('[U:1:86331856]')
        expect(result.player.team).to eq('Blue')
        expect(result.target.name).to eq('fy')
        expect(result.target.steam_id).to eq('[U:1:442791013]')
        expect(result.target.team).to eq('Blue')
        expect(result.healing).to eq(82)
        expect(result.airshot).to eq(true)
      end

      it 'parses all damage airshot log lines correctly' do
        damage_airshot_lines = airshot_log_lines.reject { |l| l.include?('healed') }
        damage_airshot_lines.each do |line|
          result = parse(line)
          expect(result).to be_a(Events::Airshot), "Expected Airshot for: #{line}"
          expect(result.airshot).to eq(true)
        end
      end

      it 'parses all heal airshot log lines correctly' do
        heal_airshot_lines = airshot_log_lines.select { |l| l.include?('healed') }
        heal_airshot_lines.each do |line|
          result = parse(line)
          expect(result).to be_a(Events::AirshotHeal), "Expected AirshotHeal for: #{line}"
          expect(result.airshot).to eq(true)
        end
      end

      it 'recognizes sniper headshot damage' do
        line = detailed_log_lines[3645]
        weapon = 'sniperrifle'
        healing = nil
        crit = nil
        headshot = '1'
        expect(Events::HeadshotDamage).to receive(:new).with(anything, anything, anything, anything, anything, anything,
                                                             anything, anything, anything, anything, weapon, healing, crit, headshot)
        parse(line).inspect
      end

      it 'ignores realdamage' do
        line = detailed_log_lines[65]
        player_name = 'LittleLies'
        player_uid = '16'
        player_steam_id = 'STEAM_0:0:55031498'
        player_team = 'Blue'
        target_name = 'Aquila'
        target_uid = '15'
        target_steam_id = 'STEAM_0:0:43087158'
        target_team = 'Red'
        value = '98'
        weapon = 'tf_projectile_pipe'
        healing = nil
        crit = nil
        headshot = nil
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name,
                                                     target_uid, target_steam_id, target_team, value, weapon, healing, crit, headshot)
        parse(line)
      end

      it 'recognizes damage with multiple optional fields' do
        line = 'L 02/02/2014 - 22:25:43: "Aquila<15><STEAM_0:0:43087158><Red>" triggered "damage" against "A \"fake\" -AA-<21><STEAM_0:0:29650428><Blue>" (damage "150") (realdamage "100") (weapon "sniperrifle") (healing "25")'
        player_name = 'Aquila'
        player_uid = '15'
        player_steam_id = 'STEAM_0:0:43087158'
        player_team = 'Red'
        target_name = 'A \"fake\" -AA-'
        target_uid = '21'
        target_steam_id = 'STEAM_0:0:29650428'
        target_team = 'Blue'
        value = '150'
        weapon = 'sniperrifle'
        healing = '25'
        crit = nil
        headshot = nil
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name,
                                                     target_uid, target_steam_id, target_team, value, weapon, healing, crit, headshot)
        parse(line)
      end

      it 'recognizes damage with crit' do
        line = 'L 02/02/2014 - 22:28:30: "krafty<20><STEAM_0:1:31326039><Red>" triggered "damage" against "guilty<26><STEAM_0:0:47824702><Blue>" (damage "2") (weapon "degreaser") (crit "crit")'
        player_name = 'krafty'
        player_uid = '20'
        player_steam_id = 'STEAM_0:1:31326039'
        player_team = 'Red'
        target_name = 'guilty'
        target_uid = '26'
        target_steam_id = 'STEAM_0:0:47824702'
        target_team = 'Blue'
        value = '2'
        weapon = 'degreaser'
        healing = nil
        crit = 'crit'
        headshot = nil
        expect(Events::Damage).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name,
                                                     target_uid, target_steam_id, target_team, value, weapon, healing, crit, headshot)
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
        player_uid = '5'
        player_steam_id = 'STEAM_0:1:12124893'
        player_team = 'Red'
        target_name = 'Epsilon numlocked'
        target_uid = '4'
        target_steam_id = 'STEAM_0:1:16347045'
        target_team = 'Red'
        value = '1'
        expect(Events::Heal).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name,
                                                   target_uid, target_steam_id, target_team, value)
        parse(line)
      end

      it 'recognizes a kill' do
        line = log_lines[1761]
        player_name = 'Epsilon basH.'
        player_uid = '7'
        player_steam_id = 'STEAM_0:1:15829615'
        player_team = 'Red'
        target_name = 'broder jukebox'
        target_uid = '11'
        target_steam_id = 'STEAM_0:1:13978585'
        target_team = 'Blue'
        weapon = 'pistol_scout'
        customkill = nil
        expect(Events::Kill).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name,
                                                   target_uid, target_steam_id, target_team, weapon, customkill)
        parse(line)
      end

      it 'recognizes headshot kills' do
        line = log_lines[1951]
        weapon = 'sniperrifle'
        customkill = 'headshot'
        expect(Events::Kill).to receive(:new).with(anything, anything, anything, anything, anything, anything, anything,
                                                   anything, anything, weapon, customkill)
        parse(line)
      end

      it 'recognizes an assist' do
        line = log_lines[1451]
        player_name = 'broder jukebox'
        player_uid = '11'
        player_steam_id = 'STEAM_0:1:13978585'
        player_team = 'Blue'
        target_name = 'Epsilon Mitsy'
        target_uid = '12'
        target_steam_id = 'STEAM_0:0:16858056'
        target_team = 'Red'
        expect(Events::Assist).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name,
                                                     target_uid, target_steam_id, target_team)
        parse(line)
      end

      it 'recognizes connect' do
        line = log_lines[9]
        name = 'Epsilon numlocked'
        uid = '4'
        steam_id = 'STEAM_0:1:16347045'
        team = ''
        message = '0.0.0.0:27005'
        expect(Events::Connect).to receive(:new).with(anything, name, uid, steam_id, team, message)
        parse(line)
      end

      it 'recognizes disconnect' do
        line = log_lines[4542]
        name = 'cc//TviQ'
        uid = '8'
        steam_id = 'STEAM_0:0:8520477'
        team = 'Blue'
        message = 'Disconnect by user.'
        expect(Events::Disconnect).to receive(:new).with(anything, name, uid, steam_id, team, message)
        parse(line)
      end

      it 'recognizes chat' do
        line = log_lines[89]
        name = 'Epsilon KnOxXx'
        uid = '5'
        steam_id = 'STEAM_0:1:12124893'
        team = 'Red'
        message = "it's right for the ping"
        expect(Events::Say).to receive(:new).with(anything, name, uid, steam_id, team, message)
        parse(line)
      end

      it 'recognizes team chat' do
        line = log_lines[303]
        name = 'broder mirelin'
        uid = '16'
        steam_id = 'STEAM_0:1:18504112'
        team = 'Blue'
        message = '>>> USING UBER <<<[info] '
        expect(Events::TeamSay).to receive(:new).with(anything, name, uid, steam_id, team, message)
        parse(line)
      end

      it 'recognizes dominations' do
        line = log_lines[1948]
        name = 'Epsilon basH.'
        uid = '7'
        steam_id = 'STEAM_0:1:15829615'
        team = 'Red'
        target_name = 'broder jukebox'
        target_uid = '11'
        target_steam_id = 'STEAM_0:1:13978585'
        target_team = 'Blue'
        expect(Events::Domination).to receive(:new).with(anything, name, uid, steam_id, team, target_name, target_uid, target_steam_id,
                                                         target_team)
        parse(line)
      end

      it 'recognizes revenges' do
        line = log_lines[2354]
        name = 'broder jukebox'
        uid = '11'
        steam_id = 'STEAM_0:1:13978585'
        team = 'Blue'
        target_name = 'Epsilon basH.'
        target_uid = '7'
        target_steam_id = 'STEAM_0:1:15829615'
        target_team = 'Red'
        expect(Events::Revenge).to receive(:new).with(anything, name, uid, steam_id, team, target_name, target_uid, target_steam_id,
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
        uid = '6'
        steam_id = 'STEAM_0:1:1895232'
        team = 'Blue'
        item = 'medkit_medium'
        expect(Events::PickupItem).to receive(:new).with(anything, name, uid, steam_id, team, item, nil)
        parse(line)
      end

      it 'recognizes stalemate round' do
        line = 'L 02/07/2013 - 21:21:08: World triggered "Round_Stalemate"'
        expect(Events::RoundStalemate).to receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes round setup begin' do
        line = 'L 04/22/2013 - 19:56:12: World triggered "Round_Setup_Begin"'
        expect(Events::RoundSetupBegin).to receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes round setup end' do
        line = 'L 04/22/2013 - 19:57:21: World triggered "Round_Setup_End"'
        expect(Events::RoundSetupEnd).to receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes mini round start' do
        line = 'L 04/22/2013 - 19:56:12: World triggered "Mini_Round_Start"'
        expect(Events::MiniRoundStart).to receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes mini round selected' do
        line = 'L 04/22/2013 - 19:56:12: World triggered "Mini_Round_Selected" (round "round_a")'
        round = 'round_a'
        expect(Events::MiniRoundSelected).to receive(:new).with(anything, round)
        parse(line)
      end

      it 'recognizes intermission win limit' do
        line = 'L 02/07/2013 - 21:52:41: Team "RED" triggered "Intermission_Win_Limit" due to mp_windifference'
        team = 'RED'
        reason = 'mp_windifference'
        expect(Events::IntermissionWinLimit).to receive(:new).with(anything, team, reason)
        parse(line)
      end

      it 'recognizes world intermission win limit' do
        line = 'L 01/24/2026 - 15:30:45: World triggered "Intermission_Win_Limit"'
        expect(Events::WorldIntermissionWinLimit).to receive(:new).with(anything)
        parse(line)
      end

      it 'recognizes ubercharges' do
        line = log_lines[1416]
        name = 'broder mirelin'
        uid = '17'
        steam_id = 'STEAM_0:1:18504112'
        team = 'Blue'
        expect(Events::ChargeDeployed).to receive(:new).with(anything, name, uid, steam_id, team)
        parse(line)

        line = detailed_log_lines[782]
        name = 'flo ❤'
        uid = '24'
        steam_id = 'STEAM_0:1:53945481'
        team = 'Blue'
        expect(Events::ChargeDeployed).to receive(:new).with(anything, name, uid, steam_id, team)
        parse(line)
      end

      it 'recognizes empty uber' do
        line = 'L 02/02/2014 - 22:09:54: "Aquila<15><STEAM_0:0:43087158><Red>" triggered "empty_uber"'
        name = 'Aquila'
        uid = '15'
        steam_id = 'STEAM_0:0:43087158'
        team = 'Red'
        expect(Events::EmptyUber).to receive(:new).with(anything, name, uid, steam_id, team)
        parse(line)
      end

      it 'recognizes charge ready' do
        line = 'L 02/02/2014 - 22:14:14: "flo ❤<24><STEAM_0:1:53945481><Blue>" triggered "chargeready"'
        name = 'flo ❤'
        uid = '24'
        steam_id = 'STEAM_0:1:53945481'
        team = 'Blue'
        expect(Events::ChargeReady).to receive(:new).with(anything, name, uid, steam_id, team)
        parse(line)
      end

      it 'recognizes charge ended' do
        line = 'L 02/02/2014 - 22:14:27: "flo ❤<24><STEAM_0:1:53945481><Blue>" triggered "chargeended" (duration "6.3")'
        name = 'flo ❤'
        uid = '24'
        steam_id = 'STEAM_0:1:53945481'
        team = 'Blue'
        duration = '6.3'
        expect(Events::ChargeEnded).to receive(:new).with(anything, name, uid, steam_id, team, duration)
        parse(line)
      end

      it 'recognizes first heal after spawn' do
        line = 'L 02/02/2014 - 22:11:38: "Aquila<15><STEAM_0:0:43087158><Red>" triggered "first_heal_after_spawn" (time "54.7")'
        name = 'Aquila'
        uid = '15'
        steam_id = 'STEAM_0:0:43087158'
        team = 'Red'
        heal_time = '54.7'
        expect(Events::FirstHealAfterSpawn).to receive(:new).with(anything, name, uid, steam_id, team, heal_time)
        parse(line)
      end

      it 'recognizes lost uber advantage' do
        line = 'L 02/02/2014 - 22:16:50: "Aquila<15><STEAM_0:0:43087158><Red>" triggered "lost_uber_advantage" (time "12")'
        name = 'Aquila'
        uid = '15'
        steam_id = 'STEAM_0:0:43087158'
        team = 'Red'
        advantage_time = '12'
        expect(Events::LostUberAdvantage).to receive(:new).with(anything, name, uid, steam_id, team, advantage_time)
        parse(line)
      end

      it 'recognizes built object' do
        line = 'L 04/22/2013 - 19:56:20: "Overdosed /Charizard<22><STEAM_0:1:31473917><Red>" triggered "builtobject" (object "OBJ_TELEPORTER") (position "440 1249 576")'
        name = 'Overdosed /Charizard'
        uid = '22'
        steam_id = 'STEAM_0:1:31473917'
        team = 'Red'
        object = 'OBJ_TELEPORTER'
        expect(Events::BuiltObject).to receive(:new).with(anything, name, uid, steam_id, team, object)
        parse(line)
      end

      it 'recognizes player extinguished' do
        line = 'L 02/02/2014 - 22:28:51: "flo ❤<24><STEAM_0:1:53945481><Blue>" triggered "player_extinguished" against "splisplesplo<23><STEAM_0:1:38937830><Blue>" with "tf_weapon_medigun" (attacker_position "-1286 500 296") (victim_position "-1553 416 296")'
        player_name = 'flo ❤'
        player_uid = '24'
        player_steam_id = 'STEAM_0:1:53945481'
        player_team = 'Blue'
        target_name = 'splisplesplo'
        target_uid = '23'
        target_steam_id = 'STEAM_0:1:38937830'
        target_team = 'Blue'
        weapon = 'tf_weapon_medigun'
        expect(Events::PlayerExtinguished).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, target_name, target_uid, target_steam_id, target_team, weapon)
        parse(line)
      end

      it 'recognizes joined team' do
        line = 'L 02/07/2013 - 21:21:19: "Epsilon numlocked<4><STEAM_0:1:16347045><Unassigned>" joined team "Blue"'
        name = 'Epsilon numlocked'
        uid = '4'
        steam_id = 'STEAM_0:1:16347045'
        team = 'Unassigned'
        team_name = 'Blue'
        expect(Events::JoinedTeam).to receive(:new).with(anything, name, uid, steam_id, team, team_name)
        parse(line)
      end

      it 'recognizes entered game' do
        line = 'L 02/07/2013 - 21:21:16: "Epsilon numlocked<4><STEAM_0:1:16347045><>" entered the game'
        name = 'Epsilon numlocked'
        uid = '4'
        steam_id = 'STEAM_0:1:16347045'
        team = ''
        expect(Events::EnteredGame).to receive(:new).with(anything, name, uid, steam_id, team)
        parse(line)
      end

      it 'recognizes medic deaths' do
        line = log_lines[1700]
        medic_name = 'broder mirelin'
        medic_uid = '17'
        medic_steam_id = 'STEAM_0:1:18504112'
        medic_team = 'Blue'
        killer_name = 'Epsilon numlocked'
        killer_uid = '4'
        killer_steam_id = 'STEAM_0:1:16347045'
        killer_team = 'Red'
        healing = '1975'
        expect(Events::MedicDeath).to receive(:new).with(anything, killer_name, killer_uid, killer_steam_id, killer_team,
                                                         medic_name, medic_uid, medic_steam_id, medic_team, healing, '0')
        parse(line)
      end

      it 'recognizes medic uberdrops' do
        uberdrop = 'L 10/04/2012 - 21:43:06: "TLR Traxantic<28><STEAM_0:1:1328042><Red>" triggered "medic_death" against "cc//Admirable<3><STEAM_0:0:154182><Blue>" (healing "6478") (ubercharge "1")'
        expect(Events::MedicDeath).to receive(:new).with(anything, anything, anything, anything, anything, anything, anything,
                                                         anything, anything, anything, '1')
        parse(uberdrop)
      end

      it 'recognizes medic healing on death' do
        line = 'L 10/04/2012 - 21:43:06: "TLR Traxantic<28><STEAM_0:1:1328042><Red>" triggered "medic_death" against "cc//Admirable<3><STEAM_0:0:154182><Blue>" (healing "6478") (ubercharge "1")'
        expect(Events::MedicDeath).to receive(:new).with(anything, anything, anything, anything, anything, anything, anything,
                                                         anything, anything, '6478', anything)
        parse(line)
      end

      it 'recognizes medic death ex' do
        line = detailed_log_lines[64]
        medic_name = 'Aquila'
        medic_uid = '15'
        medic_steam_id = 'STEAM_0:0:43087158'
        medic_team = 'Red'
        uberpct = '10'
        expect(Events::MedicDeathEx).to receive(:new).with(anything, medic_name, medic_uid, medic_steam_id, medic_team, uberpct)
        parse(line)
      end

      it 'recognizes role changes' do
        line = log_lines[1712]
        player_name = 'broder bybben'
        player_uid = '10'
        player_steam_id = 'STEAM_0:1:159631'
        player_team = 'Blue'
        role = 'scout'
        expect(Events::RoleChange).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, role)
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
        uid = '7'
        steam_id = 'STEAM_0:1:15829615'
        team = 'Red'
        cap_number = '2'
        cap_name = '#Badlands_cap_cp3'
        expect(Events::CaptureBlock).to receive(:new).with(anything, name, uid, steam_id, team, cap_number, cap_name)
        parse(line)
      end

      it 'recognizes shot_fired' do
        line = 'L 12/30/2025 - 18:34:19: "Jib<34><[U:1:367944796]><Blue>" triggered "shot_fired" (weapon "tf_projectile_rocket")'
        result = parse(line)
        expect(result).to be_a(Events::ShotFired)
        expect(result.player.name).to eq('Jib')
        expect(result.player.uid).to eq('34')
        expect(result.player.steam_id).to eq('[U:1:367944796]')
        expect(result.player.team).to eq('Blue')
        expect(result.weapon).to eq('tf_projectile_rocket')
      end

      it 'recognizes shot_hit' do
        line = 'L 12/30/2025 - 18:34:19: "Jib<34><[U:1:367944796]><Blue>" triggered "shot_hit" (weapon "tf_projectile_rocket")'
        result = parse(line)
        expect(result).to be_a(Events::ShotHit)
        expect(result.player.name).to eq('Jib')
        expect(result.player.uid).to eq('34')
        expect(result.player.steam_id).to eq('[U:1:367944796]')
        expect(result.player.team).to eq('Blue')
        expect(result.weapon).to eq('tf_projectile_rocket')
      end

      it 'recognizes position_report' do
        line = 'L 12/30/2025 - 18:34:19: "Jib<34><[U:1:367944796]><Blue>" position_report (position "306 -1464 -237")'
        result = parse(line)
        expect(result).to be_a(Events::PositionReport)
        expect(result.player.name).to eq('Jib')
        expect(result.player.uid).to eq('34')
        expect(result.player.steam_id).to eq('[U:1:367944796]')
        expect(result.player.team).to eq('Blue')
        expect(result.position).to eq('306 -1464 -237')
      end

      it 'recognizes suicides' do
        line = log_lines[76]
        name = '.schocky'
        uid = '15'
        steam_id = 'STEAM_0:0:2829363'
        team = 'Red'
        suicide_method = 'world'
        expect(Events::Suicide).to receive(:new).with(anything, name, uid, steam_id, team, suicide_method)
        parse(line)
      end

      it 'recognizes killed object' do
        line = 'L 12/30/2025 - 03:08:01: "poo<5><[U:1:435117887]><Red>" triggered "killedobject" (object "OBJ_SENTRYGUN") (weapon "obj_attachment_sapper") (objectowner "ck<24><[U:1:161147993]><Blue>") (attacker_position "-192 1630 1646")'
        player_name = 'poo'
        player_uid = '5'
        player_steam_id = '[U:1:435117887]'
        player_team = 'Red'
        object = 'OBJ_SENTRYGUN'
        weapon = 'obj_attachment_sapper'
        objectowner_name = 'ck'
        objectowner_uid = '24'
        objectowner_steam_id = '[U:1:161147993]'
        objectowner_team = 'Blue'
        expect(Events::KilledObject).to receive(:new).with(anything, player_name, player_uid, player_steam_id, player_team, object, weapon, objectowner_name, objectowner_uid, objectowner_steam_id, objectowner_team)
        parse(line)
      end

      it 'recognizes spawns' do
        line = log_lines[4541]
        name = 'candyyou # Infinity Gaming'
        uid = '124'
        steam_id = 'STEAM_0:0:50979748'
        team = 'Red'
        klass = 'Soldier'
        expect(Events::Spawn).to receive(:new).with(anything, name, uid, steam_id, team, klass)
        parse(line)
      end

      it 'recognizes rcon commands' do
        line = log_lines[4543]
        message = '"0.0.0.0:41432": command "status"'
        expect(Events::RconCommand).to receive(:new).with(anything, message)
        parse(line)
      end

      it 'deals with unknown lines' do
        line = log_lines[0]
        time = '02/07/2013 - 21:21:08'
        unknown = 'Log file started (file "logs/L0207006.log") (game "/home/hz00112/tf2/orangebox/tf") (version "5198")'
        expect(Events::Unknown).to receive(:new).with(time, unknown)
        parse(line)
      end

      it 'falls back to Unknown when keyword matches but regex does not' do
        # A triggered event with a recognized keyword but unrecognized format should
        # fall back to Unknown instead of returning nil
        line = 'L 01/24/2026 - 15:30:45: Something triggered "Round_Win" with unexpected format'
        time = '01/24/2026 - 15:30:45'
        unknown = 'Something triggered "Round_Win" with unexpected format'
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
        uid = '3'
        steam_id = 'STEAM_1:0:160621749'
        team = 'TERRORIST'
        message = '!rcon changelevel de_dust2'
        expect(Events::Say).to receive(:new).with(anything, name, uid, steam_id, team, message)
        parse(line)
      end

      it "doesn't fall for twiikuu's cheeky name" do
        line = 'L 02/07/2013 - 21:22:08: "t<1><[U:1:123456]><Red>" say "!who"<5><[U:1:1337]><Red>" say "hello world"'

        name = 't'
        uid = '1'
        steam_id = '[U:1:123456]'
        team = 'Red'
        message = '!who"<5><[U:1:1337]><Red>" say "hello world'
        expect(Events::Say).to receive(:new).with(anything, name, uid, steam_id, team, message)

        parse(line)
      end

      it 'matches damage lines with trailing newline using \A and \z' do
        line = "L 02/15/2013 - 00:21:47: \"Aka Game<4><STEAM_0:0:5253998><Red>\" triggered \"damage\" (damage \"28\")\n"
        expect(Events::Damage.regex.match(line)).not_to be_nil
      end

      it 'parses a log line with a cheeky player name containing <uid><steamid><team> and log syntax' do
        line = 'L 02/15/2013 - 00:21:47: "t<1><[U:1:123456]><Red>\" say \"!who\"<5><[U:1:1337]><Red>" say "hello world"'
        parser = TF2LineParser::Parser.new(line)
        event = parser.parse
        expect(event).to be_a(TF2LineParser::Events::Say)
        expect(event.player.name).to eq('t<1><[U:1:123456]><Red>\\" say \\"!who\\"')
        expect(event.player.uid).to eq('5')
        expect(event.player.steam_id).to eq('[U:1:1337]')
        expect(event.player.team).to eq('Red')
        expect(event.message).to eq('hello world')
      end
    end
  end
end
