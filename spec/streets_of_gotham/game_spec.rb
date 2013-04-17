require "spec_helper"

describe StreetsOfGotham::Game do
  subject { StreetsOfGotham::Game }
  let(:simple_game){subject.new("A Board")}

  describe "#initialize" do
    it {simple_game.should be_a subject}
    it {simple_game.board.should eq "A Board"}
  end
end
