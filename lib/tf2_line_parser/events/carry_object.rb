# frozen_string_literal: true

module TF2LineParser
  module Events
    class CarryObject < ObjectEvent
      def self.keyword
        'player_carryobject'
      end
    end
  end
end
