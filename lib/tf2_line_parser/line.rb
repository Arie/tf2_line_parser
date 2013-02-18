require 'time'

module TF2LineParser

  class Line

    attr_accessor :line

    def initialize(line)
      @line = line.force_encoding('UTF-8').encode('UTF-16LE', :invalid => :replace, :replace => '').encode('UTF-8')
    end

    def parse
      Events::Event.types.each do |type|
        if match = line.match(type.regex)
          @match ||= type.new(*type.regex_results(match))
          break
        end
      end
      @match
    end

  end

end
