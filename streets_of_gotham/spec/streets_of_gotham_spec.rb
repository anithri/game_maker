require "spec_helper"

describe StreetsOfGotham do
  subject {StreetsOfGotham}
  describe "#game_from" do
    it "should return a Game object" do
      game = subject.game_from({})
      game.should be_a StreetsOfGotham::Game
    end
  end
end
