require "spec_helper"

describe StreetsOfGotham::NoTile do
  subject { StreetsOfGotham::NoTile }
  it_behaves_like "a singleton"

  context "It returns a set of default values" do
    before(:all) {@tile = StreetsOfGotham::NoTile.instance}
    it {@tile.name.should be_a String}
    it {@tile.effect.should be_a StreetsOfGotham::NoEffect}
    it {@tile.location.should be_a StreetsOfGotham::NoLocation}
    it {@tile.hex_size.should eq 0}
  end
end
