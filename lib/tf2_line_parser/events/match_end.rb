module TF2LineParser
  module Events

    class MatchEnd

      attr_accessor :reason

      def initialize(reason)
        @reason = reason
      end

    end

  end
end
