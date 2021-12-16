# frozen_string_literal: true

require File.expand_path('lib/tf2_line_parser/version', __dir__)

Gem::Specification.new do |gem|
  gem.name          = 'tf2_line_parser'
  gem.version       = TF2LineParser::VERSION
  gem.date          = Time.new
  gem.summary       = 'TF2 log line parser'
  gem.description   = 'A gem to parse log lines from TF2 servers'
  gem.authors       = ['Arie']
  gem.email         = 'rubygems@ariekanarie.nl'
  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.homepage      = 'http://github.com/Arie/tf2_line_parser'

  gem.add_dependency 'activesupport'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'pry-nav'
  gem.add_development_dependency 'rspec', '~> 3.5.0'
end
