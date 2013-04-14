require "spec_helper"

describe StreetsOfGotham::TileDefinition do
  subject { StreetsOfGotham::TileDefinition }
  before(:all) do
    @tile_def = StreetsOfGotham::TileDefinition.new("A",:test,[],[],[])
  end


  describe "#initialize" do
    it {@tile_def.should be_a subject}
  end

  context "it has accessors" do
    it {@tile_def.name.should eq "A"}
    it {@tile_def.tile_type.should eq :test}
    it {@tile_def.effects.should eq []}
    it {@tile_def.tags.should eq []}
    it {@tile_def.attachments.should eq []}
  end

  describe ".is_file_type?" do
    it {@tile_def.is_tile_type?(:woot).should be_false}
    it {@tile_def.is_tile_type?(:test).should be_true}
  end
end
