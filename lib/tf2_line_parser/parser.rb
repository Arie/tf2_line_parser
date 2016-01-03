# frozen_string_literal: true
module TF2LineParser
  class Parser

    attr_accessor :line

    def initialize(line)
      @line = Line.new(line.to_s)
    end

    def parse
      line.parse
    end

  end
end
