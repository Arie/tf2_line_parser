# frozen_string_literal: true

module TF2LineParser
  module Events
    class DropObject < ObjectEvent
      def self.keyword
        'player_dropobject'
      end
    end
  end
end
