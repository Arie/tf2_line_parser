module TF2LineParser
  module Events

    class ConsoleSay

      attr_accessor :message

      def initialize(message)
        @message = message
      end

    end

  end
end
