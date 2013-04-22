require 'time'
require 'active_support/multibyte/chars'
require 'tidy_bytes_monkey_patch'

module TF2LineParser

  class Line

    attr_accessor :line

    def initialize(line)
      @line = line
    end

    def parse
      Events::Event.types.each do |type|
        begin
          match = line.match(type.regex)
        rescue ArgumentError
          tidied_line = ActiveSupport::Multibyte::Chars.new(line).tidy_bytes
          match = tidied_line.match(type.regex)
        end
        if match
          @match ||= type.new(*type.regex_results(match))
          break
        end
      end
      @match
    end

  end

end
