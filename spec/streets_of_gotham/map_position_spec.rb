require "spec_helper"

describe StreetsOfGotham::MapPosition do
  subject { StreetsOfGotham::MapPosition }
  let(:mp){subject.new(12,[3,4])}
  let(:mp_plus) do
    subject.new(12,[3,4]).tap do |a|
      a.add_route(0,:flight)
      a.add_route(22, :subway)
      a.add_route(22, :surface)
    end
  end

  describe "#initialize" do
    it {mp.should be_a subject}
    context "should initialize accessors" do
      it {mp.coordinate.should eq 12}
      it {mp.borders.should eq [3,4]}
    end
  end

  describe ".add_route" do
    it "should add a position to a mode of travel" do
      mp.travel_to?(17).should be_false
      mp.add_route(17, :surface)
      mp.travel_to?(17).should be_true
    end
  end

  describe ".travel_to?" do
    context "using the default mode" do
      it {mp.travel_to?(4).should be_true}
      it {mp.travel_to?(7).should be_false}
    end
    context "using explicit mode" do
      it {mp.travel_to?(4, [:surface]).should be_true}
      it {mp.travel_to?(7, [:surface]).should be_false}
      it {mp.travel_to?(4, [:flight]).should be_false}
      it {mp.travel_to?(7, [:flight]).should be_false}
    end
    context "using multiple modes" do
      it {mp_plus.travel_to?(0).         should be_false}
      it {mp_plus.travel_to?(0, :flight).should be_true}
      it {mp_plus.travel_to?(0,[:surface, :flight]).should be_true}
    end
  end
end
