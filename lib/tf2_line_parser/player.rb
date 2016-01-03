# frozen_string_literal: true
module TF2LineParser

  class Player

    attr_accessor :name, :steam_id, :team

    def initialize(name, steam_id, team)
      @name = name
      @steam_id = steam_id
      @team = team
    end

    def ==(other)
      steam_id == other.steam_id
    end

  end

end
