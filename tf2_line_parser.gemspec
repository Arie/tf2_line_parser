# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tf2_line_parser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'tf2_line_parser'
  gem.version       = TF2LogLineParser::VERSION
  gem.date          = Date.today
  gem.summary       = "TF2 log line parser"
  gem.description   = "A gem to parse log lines from TF2 servers"
  gem.authors       = ["Arie"]
  gem.email         = 'rubygems@ariekanarie.nl'
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.homepage      = 'http://github.com/Arie/tf2_line_parser'

  gem.add_dependency "activesupport"
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency "pry-nav",        "~> 0.2.3"
  gem.add_development_dependency "rspec",          "~> 2.13.0"
end
