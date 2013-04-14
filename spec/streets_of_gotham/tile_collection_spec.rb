require "spec_helper"

describe StreetsOfGotham::TileCollection do
  subject(:subject_class) { StreetsOfGotham::TileCollection }
  subject(:empty_tc) {StreetsOfGotham::TileCollection.new }
  subject(:filled_tc) {StreetsOfGotham::TileCollection.new({name:"A",type: :first},
                                                           {name:"B",type: :first},
                                                           {name:"C",type: :second})
  }
  describe ".initialize" do
    it "should initialize" do
      empty_tc.should be_a subject_class
    end
    it "should set tiles by default to an empty array" do
      empty_tc.tiles.should eq []
    end
    it "should have an entry in tiles for each in paramater list" do
      filled_tc.tiles.should have(3).items
    end
  end

  describe "#load_content" do
    it "should load a default file" do
      YAML.stub(:load_file).and_return([])
      YAML.should_receive(:load_file).with(::StreetsOfGotham.config.map_elements_content)
      subject_class.load_content.should be_a subject_class
    end
    it "should load a specified file" do
      YAML.stub(:load_file).and_return([])
      YAML.should_receive(:load_file).with("/tmp/some_file.yml")
      subject_class.load_content("/tmp/some_file.yml").should be_a subject_class
    end
  end

  describe ".all_tile_types" do
    it "should return an empty array for empty tiles" do
      empty_tc.all_tile_types.should eq []
    end
    it "should return a array of types" do
      filled_tc.all_tile_types.should include(:first,:second)
    end
  end
end
