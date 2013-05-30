require "spec_helper"
require 'streets_of_gotham/board'

describe StreetsOfGotham::Board do
  subject{StreetsOfGotham::Board}
  after(:each) {subject.reset!;subject.define_attribute :description, type: String, default: ""}
  describe "accessors" do
    it{subject.all_attributes.should be_a Hash}
    it{subject.all_components[:a].should == []}
    it{subject.new.config.should == {}}
    it{subject.all_attributes[:description].should be_a GameMaster::Attribute}
    it{subject.parents.should eq ["StreetsOfGotham","Board"]}
    it{subject.attribute_class.should eq GameMaster::Attribute}
  end

  describe "#method_missing" do
    let(:missing){a = subject.new; subject.all_attributes[:description].value = "Test";a}
    it{missing.description.should eq "Test"}
    it{missing.description?.should be_true}
    it "should set attribute" do
      missing.description = "AnotherTest"
      missing.description.should eq "AnotherTest"
    end
  end

  describe "#define_attribute" do
    context "When redefining" do
      it "should raise an exception with no other options set" do
        expect{subject.define_attribute(:description)}.to raise_error GameParseError
      end
      it "should send logger.warn when no other options set" do
        Yell['GameMaster'].stub(:error).and_return("warn")
        Yell['GameMaster'].should_receive(:error).with(/Refusing to redefine/)
        expect{subject.define_attribute(:description)}.to raise_error GameParseError
      end
      it "should send logger.info if opts[:may_redefine] is true" do
        Yell['GameMaster'].stub(:warn).and_return("warn")
        Yell['GameMaster'].should_receive(:warn).with(/Redefining Attribute/)
        subject.define_attribute(:description, may_redefine: true)
      end
      it "should send logger.error and not raise exception if opts[:warn_only] is set" do
        Yell['GameMaster'].stub(:error).and_return("warn")
        Yell['GameMaster'].should_receive(:error).with(/Refusing to redefine/)
        expect do
          subject.define_attribute(:description, warn_only: 1)
        end.to_not raise_error GameParseError
      end
    end
  end

end

describe "AltBoard" do
  before(:all) do
    class AltAttribute
      def initialize(*args)
      end
    end
    class AltBoard
      include ::GameMaster::Base
      define_attribute_class AltAttribute
      define_attribute :description, type: String, default: ""
    end
  end
  context "should use AltAttribute for attribute_class" do
    it{AltBoard.attribute_class.should eq AltAttribute}
    it{AltBoard.all_attributes[:description].should be_a AltAttribute}
  end
end
