require "spec_helper"

describe StreetsOfGotham::MapLayout do
  subject { StreetsOfGotham::MapLayout }
  before(:all) do
    @simple_layout = StreetsOfGotham::MapLayout.new({start: 0, bodies: [[1,2],[3,4]], end:[21,27.33]})
  end

  describe "#initialize" do
    it{@simple_layout.should be_a subject}
  end

  describe "accessors" do
    it{@simple_layout.part_types.should eq [:start, :bodies, :end]}
    it{@simple_layout.position_for_part(:start).should eq [0]}
  end
end
