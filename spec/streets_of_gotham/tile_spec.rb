require "spec_helper"

describe StreetsOfGotham::Tile do
  subject(:subject_class) { StreetsOfGotham::Tile }
  subject(:tile) { StreetsOfGotham::Tile.new(1,{name:"A", tile_type: :b, effects: [1], tags: ["xyz"],attachments:[1]})}
  describe "#initialize" do
    it "should initialize with only a name" do
      tile.should be_a subject_class
    end
    context "should initialize attributes" do
      it("should return a name"){tile.name.should eq "A"}
      it("should return a tile_type"){tile.tile_type.should eq :b}
      it("should return effects"){tile.effects.should eq [1]}
      it("should return locations"){tile.locations.should eq []}
      it("should return attachments"){tile.attachments.should eq [1]}
    end
  end
end
