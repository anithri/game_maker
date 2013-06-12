require "spec_helper"

describe StreetsOfGotham::Board do
  subject{StreetsOfGotham::Board}
  describe ".children" do
    it{subject.children_names.should include(:description,:tiles)}
  end

  describe "initialize" do
    context "when passed nothing" do
      let(:board){subject.new}
      it{board.should be_a subject}
      it{board.description.should eq ""}
      it{board.tiles.should be_a Array}
      it "should have methods" do
        board.methods.should include(:description, :description=, :description?)
        board.methods.should include(:tiles, :add_tiles)
      end
    end

    context "when assignments are made" do
      let(:board){subject.new}
      it "should do assignments" do
        board.description = "Testing"
        board.description.should eq "Testing"
        board.add_tiles(name: "Testing")
        board.tiles.first.should be_a StreetsOfGotham::Tile
        board.tiles.first.name.should eq "Testing"
      end
      it "should raise an error when passed an incorrect type" do
        #expect{board.description = 12}.to raise_error GameParseError
        #expect{board.add_tiles("hiya")}.to raise_error(/abc/)
      end
    end

    context "when passed a hash with a description key" do
      let(:board){subject.new(description: "Woot")}
      it "should set the description attribute" do
        board.description.should eq "Woot"
      end
      #TODO PICK UP HERE
    end


  end
end