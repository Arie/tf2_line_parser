module TF2LineParser
  class Parser

    attr_accessor :line, :time, :event

    def initialize(line)
      @line = Line.new(line.to_s)
    end

    def parse
      line.parse
    end

  end
end
