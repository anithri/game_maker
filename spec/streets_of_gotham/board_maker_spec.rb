require "spec_helper"

describe StreetsOfGotham::BoardMaker do
  subject { StreetsOfGotham::BoardMaker }

  describe "#mk_board" do
    it {subject.should respond_to(:mk_board)}
    it {subject.mk_board.should be_a StreetsOfGotham::Board }
  end

end
