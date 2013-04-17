require "spec_helper"

describe StreetsOfGotham::MapPosition do
  subject { StreetsOfGotham::MapPosition }
  let(:simple_position) {subject.new(0, [1,2,3,4,5,6])}

  describe "#initialize" do
    it {simple_position.should be_a subject}
    it {simple_position.coordinate.should eq 0}
    it {simple_position.borders.should eq [1,2,3,4,5,6]}
  end
end
