require "spec_helper"

describe StreetsOfGotham::HexMap do
  subject { StreetsOfGotham::HexMap }

  describe "#load_content" do
    before(:all) do
      YAML.stub(:load_file).and_return([1,2,99])
      it {subject.new("test").positions.should have_3_items}
    end
  end

  describe ".initialize" do
    it {subject.new([],String).should be_a subject}
    context "It initializes variables" do
      it {subject.new(["abc"], String).positions.should eq ["abc"]}
    end
  end

  describe ".map_for_assignment" do
    before(:all) do
      class TestPosition
        attr_reader :coordinate
        def initialize(var)
          @coordinate = var
        end
      end
      @map = StreetsOfGotham::HexMap.new([2,5,17,42],TestPosition )
    end

    it {@map.positions_for_assignment.should be_a Hash}
    it {@map.positions_for_assignment.keys.should have_exactly(4).items}
  end
end
