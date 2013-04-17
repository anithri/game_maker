require "spec_helper"

describe StreetsOfGotham do
  subject {StreetsOfGotham}
  after(:all) {subject.reset_config}
  it {subject.config.should be_a OpenStruct}

  describe "#config" do
    it {subject.config.should be_a OpenStruct}
  end

  describe "#reset_config" do
    it "should undo any changes" do
      subject.config.foo = 1
      subject.config.bar = 2
      subject.reset_config
      subject.config.foo.should be_nil
      subject.config.bar.should be_nil
    end
  end

  describe "#load_config" do
    it "should replace default settings with options" do
      subject.config.data_dir.should be_a String
      subject.load_config({a: 123, b: 432})
      subject.config.a.should eq 123
      subject.config.b.should eq 432
      subject.config.data_dir.should be_nil
    end
  end

  describe "#mk_game" do
    it {subject.mk_game.should be_a StreetsOfGotham::Game}
  end
end