require "spec_helper"

describe GameMaster::Attribute do
  subject{GameMaster::Attribute}
  describe "#initializer" do
    let(:attribute) {subject.new(:test, String, "")}
    it{attribute.should be_a subject}
    it{attribute.name.should eq :test}
    it{attribute.type.should eq String}
    it{attribute.default.should eq ""}
    it{attribute.opts.should == {}}
    it{attribute.value.should eq ""}
  end

  describe "#value=" do
    let(:attribute) {subject.new(:test, String, "foobar")}
    let(:define_msg){"New attribute defined: Test<String>"}

    before(:each) do
      @logger = double("logger", warn: "warn", info: "info")
      Yell::Repository.loggers['GameMaster'] = @logger
    end

    context "with no options set" do
      it "should return the new value" do
        info_msg = "assigned to attribute Test: \"Test\""
        @logger.should_receive(:info).twice
        attribute.send(:value=, "Test").should eq "Test"
      end

      it "should raise an ArgumentError" do
        warn_msg = "failed assignment to attribute Test<String>: 123<Fixnum>"
        @logger.should_receive(:warn).with(warn_msg)
        @logger.should_receive(:info).with(define_msg)
        expect{attribute.send(:value=, 123)}.to raise_error ArgumentError
      end
    end

    context "with opts[:ignore_type] set to true" do
      let(:attribute) {subject.new(:test, String, "foobar", ignore_type: true)}
      it "should return the new value" do
        @logger.should_receive(:info).twice
        attribute.send(:value=, "Test").should eq "Test"
      end
      it "should return the new value" do
        @logger.should_receive(:info).twice
        attribute.send(:value=, 123).should eq 123
      end
    end

    context "with opts[:warn_only] set to true" do
      let(:attribute) {subject.new(:test, String, "foobar", warn_only: true)}
      it "should return the new value" do
        @logger.should_receive(:info).twice
        attribute.send(:value=, "Test").should eq "Test"
      end
      it "should return the old value" do
        @logger.should_receive(:info).ordered
        @logger.should_receive(:warn).ordered
        attribute.send(:value=, 123).should eq "foobar"
      end
    end

    context "with opts[:parent] set" do
      let(:attribute) {subject.new(:test, String, "foobar", parents: GameMaster)}

      it "should return the new value" do
        info_msg = "  assigned to attribute GameMaster::Test: \"Test\""
        @logger.should_receive(:info).with(info_msg)
        attribute.value= "Test"
      end

      it "should return the old value" do
        warn_msg = "  failed assignment to attribute GameMaster::Test<String>: 123<Fixnum>"
        @logger.should_receive(:warn).with(warn_msg)
        expect{attribute.send(:value=, 123)}.to raise_error ArgumentError
      end

      it "should accept multiple parents" do
        info_msg = "      assigned to attribute GameMaster::FooBar::BazBaz::Test: \"Test\""
        @logger.should_receive(:info).with(info_msg)
        attribute.opts[:parents] = [GameMaster, :foo_bar, "bazBaz"]
        attribute.value= "Test"
      end

      it "should send the proper define message when passed 1 parent" do
        define_msg = "  New attribute defined: GameMaster::Test<String>"
        @logger.should_receive(:info).with(define_msg)
        subject.new(:test, String, "foobar", parents: GameMaster)
      end

      it "should send the proper define message when passed 2 parent" do
        define_msg = "    New attribute defined: GameMaster::Base::Test<String>"
        @logger.should_receive(:info).with(define_msg)
        subject.new(:test, String, "foobar", parents: [GameMaster,"Base"])
      end
    end

    describe "#parents" do
      let(:attribute){subject.new(:test, String, "foobar")}
      it{attribute.parents.should eq []}
      it "should return right array" do
        attribute.opts[:parents] = nil
        attribute.parents.should eq []
      end

      it "should return right array" do
        attribute.opts[:parents] = []
        attribute.parents.should eq []
      end

      it "should return right array" do
        attribute.opts[:parents] = "abc_d"
        attribute.parents.should eq ["abc_d"]
      end

      it "should return right array" do
        attribute.opts[:parents] = :abc_d
        attribute.parents.should eq [:abc_d]
      end

      it "should return right array" do
        attribute.opts[:parents] = String
        attribute.parents.should eq [String]
      end

      it "should return right array" do
        attribute.opts[:parents] = ["abc_d"]
        attribute.parents.should eq ["abc_d"]
      end

      it "should return right array" do
        attribute.opts[:parents] = [:abc_d]
        attribute.parents.should eq [:abc_d]
      end

      it "should return right array" do
        attribute.opts[:parents] = [String, :abc_d]
        attribute.parents.should eq [String, :abc_d]
      end

      it "should return right array" do
        attribute.opts[:parents] = ["abc_d", String]
        attribute.parents.should eq ["abc_d", String]
      end

      it "should return right array" do
        attribute.opts[:parents] = [String, Fixnum, "Ab"]
        attribute.parents.should eq [String, Fixnum, "Ab"]
      end
    end

    describe "#full_name" do
      let(:correct_full_name){"GameMaster::Test::FooBar::Baz::Test"}
      let(:base_attribute){subject.new(:test, String, "foobar")}
      shared_examples "a correct full_name" do
        it{attribute.full_name.should eq correct_full_name}
      end

      it_should_behave_like "a correct full_name" do
        let(:parents_array){[:GameMaster,"Test","foo_bar","Baz"]}
        let(:attribute){base_attribute.opts[:parents] = parents_array;base_attribute}
      end

      it_should_behave_like "a correct full_name" do
        let(:parents_array){[GameMaster,"test",:fooBar,"baz"]}
        let(:attribute){base_attribute.opts[:parents] = parents_array;base_attribute}
      end

      it_should_behave_like "a correct full_name" do
        let(:parents_array){["game_master","Test","foo_bar","baz"]}
        let(:attribute){base_attribute.opts[:parents] = parents_array;base_attribute}
      end

    end
  end
end