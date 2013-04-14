require "spec_helper"

describe StreetsOfGotham::Location do
  subject(:subject_class) { StreetsOfGotham::Location }
  subject(:location) {StreetsOfGotham::Location.new("Test")}

  describe "#initialize" do
    it "should initialize with only a name" do
      location.should be_a subject_class
    end
    context "sets attributes" do
      it("Should return a name"){location.name.should eq "Test"}
      it("Should return an effect"){location.effect.should be_a StreetsOfGotham::NoEffect}
    end
  end
end
