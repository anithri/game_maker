require "spec_helper"

describe StreetsOfGotham do
  subject {StreetsOfGotham}

  describe "#mk_game" do
    it {subject.game_from.should be_a StreetsOfGotham::Game}
  end
end