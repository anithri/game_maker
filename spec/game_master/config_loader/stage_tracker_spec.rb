require 'spec_helper'

describe GameMaster::ConfigLoader::StageTrackerBase do
  subject { GameMaster::ConfigLoader::StageTrackerBase }
  let(:expected_stages){GameMaster::ConfigLoader::DEFAULT_STAGES.map(&:last)}

  let(:empty_tracker) {subject.new}
  let(:fake_stage){Module.new{def self.load;end}}
  let(:invalid_stage){Module.new}
  let(:tracker) {t = subject.new;t.register_stage(fake_stage,10);t}

  it{empty_tracker.stages.should be_empty}

  describe "#is_valid_stage?" do
    it "should return true for all built-in stages" do
      expected_stages.all?{|stage| empty_tracker.is_valid_stage?(stage)}
    end

    it "should return true for valid stage" do
      empty_tracker.is_valid_stage?(fake_stage).should be_true
    end

    it "should return false for all invalid stages" do
      empty_tracker.is_valid_stage?("Test").should be_false
      empty_tracker.is_valid_stage?(invalid_stage).should be_false
    end

  end

  describe ".register_stage" do
    it "should raise ArgumentError if given an invalid stage" do
      expect{tracker.register_stage("test",10)}.to raise_error ArgumentError
    end

    it "should register stages" do
      tracker.stages.should eq [fake_stage]
    end
    it "should not add the same stage more than once" do
      tracker.register_stage(fake_stage,10)
      tracker.stages.should eq [fake_stage]
    end
  end

  describe ".unregister_stage" do
    it "should unregister stages" do
      tracker.unregister_stage(fake_stage,10)
      tracker.stages.should eq []
    end
    it "should do nothing if asked to remove a stage it hasn't tracked" do
      tracker.unregister_stage("test",10)
      tracker.stages.should eq [fake_stage]
    end
  end

  describe "stages" do
    it "should return stages in priority_order" do
      two = Module.new{def self.load;end}
      three = Module.new{def self.load;end}
      tracker.register_stage(two,5)
      tracker.register_stage(three,1)
      tracker.stages.should eq [three, two, fake_stage]
    end

  end

end

