require "spec_helper"

describe GameMaster::Game do
  subject{GameMaster::Game}
  describe ".initialize" do

    context "sets of accessors" do
      it{subject.new({}).config.should == {}}
    end

  end
end