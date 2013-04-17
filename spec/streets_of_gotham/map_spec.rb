require "spec_helper"

describe StreetsOfGotham::Map do
  subject { StreetsOfGotham::Map }
  before(:all) do
    @simple_map = StreetsOfGotham::Map.new("Test Map", [{coordinate: 1, borders:[1]}])
    @simple_position = @simple_map.spaces.first
  end

  describe "#initialize" do
    it {@simple_map.should be_a subject}
  end

  describe "accessors" do
    it {@simple_map.board_name.should eq "Test Map" }
    it {@simple_map.spaces.should be_a Array }
    it {@simple_map.spaces.should have(1).item }
    it {@simple_map.spaces.first.should be_a StreetsOfGotham::MapPosition}

  end

  describe ".as_map" do
    it {@simple_map.as_map.should be_a Hash}
    it {@simple_map.as_map.keys.should == [1] }
  end

end
