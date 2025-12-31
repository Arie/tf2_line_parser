# frozen_string_literal: true

require 'tf2_line_parser/version'
require 'tf2_line_parser/parser'
require 'tf2_line_parser/player'

require 'tf2_line_parser/events/event'
require 'tf2_line_parser/events/pvp_event'
require 'tf2_line_parser/events/player_action_event'
require 'tf2_line_parser/events/round_event_without_variables'
require 'tf2_line_parser/events/round_event_with_variables'
require 'tf2_line_parser/events/connect'
require 'tf2_line_parser/events/score'
require 'tf2_line_parser/events/role_change'
require 'tf2_line_parser/events/damage'
require 'tf2_line_parser/events/heal'
Dir["#{File.dirname(__FILE__)}/tf2_line_parser/events/*.rb"].sort.each { |file| require file }
require 'tf2_line_parser/line'

module TF2LineParser
end
