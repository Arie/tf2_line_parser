# frozen_string_literal: true

require 'time'

module TF2LineParser
  class Line
    attr_accessor :line

    # Keyword to event types mapping (order matters for subtypes!)
    KEYWORD_DISPATCH = {
      'shot_fired' => [Events::ShotFired],
      'shot_hit' => [Events::ShotHit],
      'damage' => :check_damage_subtypes,
      'healed' => :check_heal_subtypes,
      'picked up' => [Events::PickupItem],
      'kill assist' => [Events::Assist],
      'killed' => [Events::Kill],
      'killedobject' => [Events::KilledObject],
      'captureblocked' => [Events::CaptureBlock],
      'pointcaptured' => [Events::PointCapture],
      'chargedeployed' => [Events::ChargeDeployed],
      'medic_death_ex' => [Events::MedicDeathEx],
      'medic_death' => [Events::MedicDeath],
      'empty_uber' => [Events::EmptyUber],
      'chargeready' => [Events::ChargeReady],
      'chargeended' => [Events::ChargeEnded],
      'first_heal_after_spawn' => [Events::FirstHealAfterSpawn],
      'lost_uber_advantage' => [Events::LostUberAdvantage],
      'builtobject' => [Events::BuiltObject],
      'player_builtobject' => [Events::BuiltObject],
      'player_extinguished' => [Events::PlayerExtinguished],
      'joined team' => [Events::JoinedTeam],
      'entered the game' => [Events::EnteredGame],
      'changed role' => [Events::RoleChange],
      'spawned as' => [Events::Spawn],
      'committed suicide' => [Events::Suicide],
      'domination' => [Events::Domination],
      'revenge' => [Events::Revenge],
      'Round_Win' => [Events::RoundWin],
      'Round_Length' => [Events::RoundLength],
      'Round_Start' => [Events::RoundStart],
      'Round_Setup_Begin' => [Events::RoundSetupBegin],
      'Round_Setup_End' => [Events::RoundSetupEnd],
      'Mini_Round_Start' => [Events::MiniRoundStart],
      'Mini_Round_Selected' => [Events::MiniRoundSelected],
      'Intermission_Win_Limit' => [Events::IntermissionWinLimit],
      'Round_Stalemate' => [Events::RoundStalemate],
      'Game_Over' => [Events::MatchEnd],
      'connected, address' => [Events::Connect],
      'disconnected' => [Events::Disconnect],
      'say_team' => [Events::TeamSay],
      'say "' => [Events::Say],
      'position_report' => [Events::PositionReport],
    }.freeze

    # Fallback types when no keyword matches
    FALLBACK_TYPES = [
      Events::CurrentScore, Events::FinalScore, Events::RconCommand,
      Events::ConsoleSay, Events::Unknown
    ].freeze

    def initialize(line)
      @line = line
    end

    def parse
      self.class.parse(@line)
    end

    # Class method to parse without object allocation
    def self.parse(line)
      types = find_candidate_types(line)
      try_parse_types(line, types)
    end

    class << self
      private

      def find_candidate_types(line)
        # Fast path: check for "triggered" which covers most events
        if line.include?('triggered "')
          start_idx = line.index('triggered "')
          if start_idx
            end_idx = line.index('"', start_idx + 11)
            if end_idx
              keyword = line[start_idx + 11...end_idx]
              result = KEYWORD_DISPATCH[keyword]
              if result
                case result
                when :check_damage_subtypes
                  return check_damage_subtypes(line)
                when :check_heal_subtypes
                  return check_heal_subtypes(line)
                else
                  return result
                end
              end
            end
          end
        end

        # Check other common patterns with simple string operations
        if line.include?('" killed "')
          [Events::Kill]
        elsif line.include?('position_report')
          [Events::PositionReport]
        elsif line.include?('" say_team "')
          [Events::TeamSay]
        elsif line.include?('" say "')
          [Events::Say]
        elsif line.include?('picked up item')
          [Events::PickupItem]
        elsif line.include?('joined team "')
          [Events::JoinedTeam]
        elsif line.include?('entered the game')
          [Events::EnteredGame]
        elsif line.include?('changed role to')
          [Events::RoleChange]
        elsif line.include?('spawned as "')
          [Events::Spawn]
        elsif line.include?('committed suicide')
          [Events::Suicide]
        elsif line.include?('connected, address')
          [Events::Connect]
        elsif line.include?('disconnected (reason')
          [Events::Disconnect]
        else
          FALLBACK_TYPES
        end
      end

      def try_parse_types(line, types)
        types.each do |type|
          begin
            match = line.match(type.regex)
          rescue ArgumentError
            # Handle invalid byte sequences by forcing UTF-8 encoding
            tidied_line = line.encode('UTF-8', 'UTF-8', invalid: :replace, undef: :replace, replace: '')
            match = tidied_line.match(type.regex)
          end
          return type.new(*type.regex_results(match)) if match
        end
        nil
      end

      def check_damage_subtypes(line)
        damage_attr_pos = line.index('(damage "')
        return [Events::Damage] unless damage_attr_pos

        suffix = line[damage_attr_pos..-1]
        if suffix.include?('(headshot "')
          [Events::HeadshotDamage]
        elsif suffix.include?('(airshot "')
          [Events::Airshot]
        else
          [Events::Damage]
        end
      end

      def check_heal_subtypes(line)
        heal_attr_pos = line.index('(healing "')
        return [Events::Heal] unless heal_attr_pos

        suffix = line[heal_attr_pos..-1]
        if suffix.include?('(airshot "')
          [Events::AirshotHeal]
        else
          [Events::Heal]
        end
      end
    end
  end
end
