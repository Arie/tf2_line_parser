require 'time'

module TF2LineParser

  class Line

    attr_accessor :line

    def initialize(line)
      @line = reencode(line)
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

    private

    # Re-encode chars between 0x80 and 0xFF to UTF-8
    def reencode(line)
      reencoded_chars = line.chars.map do |chr|
        ordinal = ordinal(chr)
        case ordinal
        when (0x80..0xFF)
          [ordinal].pack("U*")
        else
          chr
        end
      end

      reencoded_chars.join
    end

    def ordinal(char)
      begin
        char.ord
      rescue ArgumentError
        char.bytes.first.ord
      end
    end

  end

end
