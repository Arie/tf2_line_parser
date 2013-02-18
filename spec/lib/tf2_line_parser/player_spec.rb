require 'spec_helper'


module TF2LineParser

  describe Player do

    it "compares based on steam_id" do
      p1 = Player.new("Arie", "12345", "Red")
      p2 = Player.new("Arie fakenicking", "12345", "Red")
      p1.should eq p2
    end

  end
end
