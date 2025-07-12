# frozen_string_literal: true

module TF2LineParser
  class Player
    attr_accessor :name, :uid, :steam_id, :team

    def initialize(name, uid, steam_id, team)
      @name = name
      @uid = uid
      @steam_id = steam_id
      @team = team
    end

    def ==(other)
      steam_id == other.steam_id
    end
  end
end
