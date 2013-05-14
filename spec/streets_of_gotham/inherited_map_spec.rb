require "spec_helper"

describe StreetsOfGotham::InheritedMap do
  subject { StreetsOfGotham::InheritedMap }
  let(:position_class) {StreetsOfGotham::MapPosition}
  before(:all) do
    @simple_options = {board_name: "Test Map",
                      positions:  [{coordinate: 1, borders:[1]}]}
    @simple_map = StreetsOfGotham::Map.new(@simple_options)
    @simple_position = @simple_map.at_coordinate(1)
  end

  describe "#valid?" do
    it{subject.valid?(@simple_options).should be_true}
    it "should be invalid if options is not a hash" do
      subject.valid?("Hi").should be_false
    end

    context "With an incomplete options hash" do
    before(:each){@bad_options = @simple_options.dup}
      context "should be invalid is options does not contain specific keys" do
        it "needs a board_game key" do
          @bad_options.delete(:board_name)
          subject.valid?(@bad_options).should be_false
        end
        it "needs a positions key" do
          @bad_options.delete(:positions)
          subject.valid?(@bad_options).should be_false
        end
      end
      context "should be invalid if keys do not contain specific classes" do
        it "needs an array as the positions value" do
          @bad_options[:positions] = "Test"
          subject.valid?(@bad_options).should be_false
        end
      end
    end
  end


  describe "#initialize" do
    it {@simple_map.should be_a subject}
  end

  describe "accessors" do
    it {@simple_map.board_name.should eq "Test Map" }
    it {@simple_map.spaces.should be_a Hash }
    it {@simple_map.spaces.keys.should have(1).item }
    it {@simple_map.spaces[1].should be_a position_class }
  end

end
