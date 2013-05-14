require "spec_helper"

describe StreetsOfGotham do
  subject {StreetsOfGotham}

  describe "#mk_game" do
    it {subject.mk_game.should be_a StreetsOfGotham::Game}
  end
end