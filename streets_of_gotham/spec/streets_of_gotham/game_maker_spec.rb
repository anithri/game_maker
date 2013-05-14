require "spec_helper"

describe StreetsOfGotham::GameMaker do
  subject { StreetsOfGotham::GameMaker }

  describe "#mk_game" do
    it {subject.mk_game.should be_a StreetsOfGotham::Game}
  end
end
