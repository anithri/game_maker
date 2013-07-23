require "spec_helper"

describe GameMaster::Base do
  let(:test_class) do
    Class.new do
      include GameMaster::Base
      define_attributes do
        attr :description, String, default: ""
        collection :tiles, String
      end
    end
  end
  let(:empty_config){GameMaster::Config.new()}

  describe "accessors" do
    it{test_class.attributes.should be_a Hash}
    it{test_class.collections.should be_a Hash}
    it{test_class.attributes[:description].should be_a Attrio::Attribute}
    it{test_class.collections[:tiles].should be_a Attrio::Collection}
    it{test_class.new(empty_config).config.config.should == {}}
    it{test_class.parents.should eq []}
  end

  describe "TestClass.description" do
    let(:missing){a = test_class.new(empty_config); a.description="Test";a}
    it{missing.description.should eq "Test"}
    it "should set attribute" do
      missing.description = "AnotherTest"
      missing.description.should eq "AnotherTest"
    end
  end

  describe "TestClass.tiles" do
    let(:missing){a = test_class.new(empty_config); a.add_tiles("Test","Me");a}
    it{missing.tiles.should be_a Array}
    it{missing.tiles.should eq ["Test","Me"]}
    it{missing.has_tiles?("Test").should be_true}

    it "should set collection" do
      missing.add_tiles "AnotherTest"
      missing.tiles.last.should eq "AnotherTest"
    end
  end
end
