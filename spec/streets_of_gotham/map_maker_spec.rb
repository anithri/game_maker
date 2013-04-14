require "spec_helper"

describe StreetsOfGotham::MapMaker, focus: true do
  subject { StreetsOfGotham::MapMaker }

  it "should return a map" do
    a = subject.mk_map
    a.should be_a ::StreetsOfGotham::GameMap
  end
end
