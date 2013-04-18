require "spec_helper"

describe StreetsOfGotham::Map, focus: true  do
  subject { StreetsOfGotham::Map }
  let(:position_class) {StreetsOfGotham::MapPosition}
  before(:all) do
    @simple_map = StreetsOfGotham::Map.new("Test Map", [{coordinate: 1, borders:[1]}])
    @simple_position = @simple_map.at_coordinate(1)
  end

  describe "#initialize" do
    it {@simple_map.should be_a subject}
  end

  describe "accessors" do
    it {@simple_map.board_name.should eq "Test Map" }
    it {@simple_map.spaces.should be_a Hash }
    it {@simple_map.spaces.keys.should have(1).item }
    it {@simple_map.spaces[1].should be_a position_class }
  end

end
