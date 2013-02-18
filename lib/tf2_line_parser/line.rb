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

    Events::Event.types.each do |klass|
      define_method(klass.to_method_name) { line.match(regex_results(klass.regex, klass.attributes)) }
    end

  end

end
