require "spec_helper"

describe StreetsOfGotham::Board do
  subject{StreetsOfGotham::Board}
  describe ".all_children" do
    it{subject.all_children.keys.should include(:attribute,:collection)}
    it{subject.all_children[:attribute].keys.should eq [:description]}
    it{subject.all_children[:collection].keys.should eq [:tiles]}
  end

  describe "initialize" do
    context "when passed nothing" do
      let(:board){subject.new}
      it{board.should be_a subject}
      it{board.description.should eq ""}
      it{board.tiles.should be_a Array}
    end

    context "when passed a hash with a description key" do
      let(:board){subject.new(description: "Woot")}
      it "should set the description attribute" do
        binding.pry
        board.description.should eq "Woot"
      end
      #TODO PICK UP HERE
    end

  end
end