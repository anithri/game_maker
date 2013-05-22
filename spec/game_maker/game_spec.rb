require "spec_helper"

describe GameMaker::Game do
  subject{GameMaker::Game}
  describe ".initialize" do

    context "sets of accessors" do
      it{subject.new({}).config.should == {}}
    end

  end
end