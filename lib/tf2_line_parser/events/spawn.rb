# frozen_string_literal: true
module TF2LineParser
  module Events

    class Spawn < RoleChange

      def self.action_text
        @action_text ||= "spawned as".freeze
      end

    end
  end
end
