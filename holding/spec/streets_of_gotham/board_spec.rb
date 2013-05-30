require "spec_helper"

describe StreetsOfGotham::Board do
  subject { StreetsOfGotham::Board }
  let(:simple_board) { subject.new }
  describe "#initialize" do
    it {simple_board.should be_a subject}
  end

  descr
end
