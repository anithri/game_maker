require "spec_helper"

describe StreetsOfGotham::Tile do
  subject{StreetsOfGotham::Tile}

  describe ".children" do
    it{subject.children_names.should include(:name, :tile_type)}

  end

  describe "child methods" do
    let(:tile){subject.new(name: "Testing")}
    context "for name" do
      it "should have name instance methods" do
        tile.methods.should include(:name, :name=, :name?)
      end
      it "should have name class methods" do
        subject.methods.should include(:name_default, :name_type)
      end
    end

    context "for name" do
      it "should have name instance methods" do
        tile.methods.should include(:tile_type, :tile_type=, :tile_type?)
      end
      it "should have name class methods" do
        subject.methods.should include(:tile_type_default, :tile_type_type)
      end
    end
  end

  describe "#initialzie" do
    context "when passed nothing" do
      let(:tile){subject.new(name: "Testing")}
      it{tile.should be_a subject}
      it{tile.name.should eq "Testing"}
      it{tile.tile_type.should eq nil}
    end
  end
end