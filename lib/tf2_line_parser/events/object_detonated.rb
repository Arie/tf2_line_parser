# frozen_string_literal: true

module TF2LineParser
  module Events
    class ObjectDetonated < ObjectEvent
      def self.keyword
        'object_detonated'
      end
    end
  end
end
