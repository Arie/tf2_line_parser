# frozen_string_literal: true

require 'simplecov'
require 'coveralls'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'pry-nav'
require 'tf2_line_parser'
