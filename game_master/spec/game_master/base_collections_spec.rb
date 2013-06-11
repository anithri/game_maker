require "spec_helper"

describe GameMaster::BaseCollections do
  let(:test_class) do
    Class.new do
      include GameMaster::Base
      define_collection :test_this, type: String
    end
  end

  describe ".collection_class" do
    it{test_class.collection_class.should eq GameMaster::Collection}
  end

  describe ".define_collection_class" do
    it "should set a attribute_class to new value" do
      test_class.define_collection_class(String)
      test_class.collection_class.should eq String
    end
    it "should log an info message" do
      test_class #makes sure we're not catching log stuff for class creation
      Yell['GameMaster'].should_receive(:info).with(/Defining new Collection Class/)
      test_class.define_collection_class(String)
    end
  end

  describe "#define_attribute" do
    describe "should create methods" do
      it{test_class.instance_methods(false).should include(:test_this)}
      it{test_class.instance_methods(false).should include(:test_this)}
      it{test_class.instance_methods(false).should include(:test_this_type)}
    end
    describe "should set variables" do
      it{test_class.all_children.keys.should include(:test_this)}
    end

    it "should raise error when redefined attribute" do
      test_class
      Yell['GameMaster'].should_receive(:error).with(/Refusing to redefine test_this/)
      expect{test_class.define_attribute :test_this}.to raise_error GameParseError
    end

    context "when :warn_only opt is set to true" do
      it "should log an error" do
        test_class
        Yell['GameMaster'].should_receive(:error).with(/Refusing to redefine test_this/)
        test_class.define_attribute :test_this, warn_only: true
      end
    end

    context "When :may_redefine opt is set to true" do
      it "should redefine the given attribute" do
        test_class.send(:define_attribute, :test_this, type: Integer, default: 0,
                        may_redefine: true)
        test_class.all_children[:test_this].type.should eq Integer
        test_class.all_children[:test_this].default.should eq 0
      end
      it "should log a warning" do
        test_class
        Yell['GameMaster'].should_receive(:warn).with(/Redefining Attribute test_this for /)
        test_class.send(:define_attribute, :test_this, type: Integer, default: 0,
                        may_redefine: true)
      end
    end

  end
end
