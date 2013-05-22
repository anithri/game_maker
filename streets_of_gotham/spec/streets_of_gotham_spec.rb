require "spec_helper"

describe StreetsOfGotham do
  subject {StreetsOfGotham}
  let(:game){subject.game_from}
  describe "#mk_game" do
    it {game.should be_a StreetsOfGotham::Game}
  end
end
