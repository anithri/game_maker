require "spec_helper"

describe StreetsOfGotham::MapPosition do
  subject { StreetsOfGotham::MapPosition }
  let(:initial_hash){ {coordinate: 0, borders: [1,2,3,4,5,6]} }
  let(:simple_position){ subject.new(initial_hash) }

  describe ".initialize" do
    it {simple_position.should be_a subject}
    it {simple_position.coordinate.should eq 0}
    it {simple_position.borders.should eq [1,2,3,4,5,6]}
    it {simple_position.raw_data.should eq initial_hash}
  end

  describe "#valid?" do
    it {subject.valid?({coordinate: 1, borders: [1,2]}).should be_true}
    it {subject.valid?({borders: [1,2]}).should be_false}
    it {subject.valid?({coordinate: nil, borders: [1,2]}).should be_false}
    it {subject.valid?({coordinate: 1}).should be_false}
    it {subject.valid?({coordinate: 1, borders: :oops}).should be_false}
  end
end
