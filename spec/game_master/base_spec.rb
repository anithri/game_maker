require "spec_helper"

describe GameMaster::Base do
  let(:test_class) do
    Class.new do
      include GameMaster::Base
      define_attribute :description, type: String, default: ""
      define_collection :tiles
    end
  end

  describe "accessors" do
    it{test_class.all_children.should be_a Hash}
    it{test_class.all_children[:tiles].should be_a GameMaster::Collection}
    it{test_class.new.config.should == {}}
    it{test_class.all_children[:description].should be_a GameMaster::Attribute}
    it{test_class.parents.should eq []}
    it{test_class.attribute_class.should eq GameMaster::Attribute}
  end

  describe "#method_missing" do
    let(:missing){a = test_class.new; test_class.all_children[:attribute][:description].value =
        "Test";a}
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
        expect{test_class.define_attribute(:description)}.to raise_error GameParseError
      end

      it "should send logger.warn when no other options set" do
        Yell['GameMaster'].should_receive(:error).with(/Refusing to redefine/)
        expect{test_class.define_attribute(:description)}.to raise_error GameParseError
      end

      it "should send logger.info if opts[:may_redefine] is true" do
        Yell['GameMaster'].should_receive(:warn).with(/Redefining Attribute/)
        test_class.define_attribute(:description, may_redefine: true)
      end

      it "should send logger.error and not raise exception if opts[:warn_only] is set" do
        Yell['GameMaster'].should_receive(:error).with(/Refusing to redefine/)
        expect do
          test_class.define_attribute(:description, warn_only: 1)
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
    it{AltBoard.all_children[:attribute][:description].should be_a AltAttribute}
  end
end
