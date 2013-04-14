require "spec_helper"

describe StreetsOfGotham::GameMap do
  subject { StreetsOfGotham::GameMap }

  describe "#initialize" do
    it  {subject.new.should be_a subject}
  end
end
