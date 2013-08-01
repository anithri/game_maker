require "spec_helper"

describe GameMaster::ConfigLoader do
  subject { GameMaster::ConfigLoader }
  let(:tracker) {subject::STAGE_TRACKER}
  let(:expected_stages){GameMaster::ConfigLoader::DEFAULT_STAGES.map(&:last)}

  it "Should have default stages" do
    tracker.stages.should eq expected_stages
  end

  describe ".load(game, loader, runtime)" do
  #  it "should return a GameMaster::Config object" do
  #    subject.clear_all_stages
  #    subject::CONFIG_STAGES should eq []
  #    subject.load({},{},{}).should be_a GameMaster::Config
  #  end
  #
  #  it "should call .load on every object in CONFIG_STAGES" do
  #    subject.clear_all_stages
  #    3.times do |i|
  #      stage = double("Stage_#{i}")
  #      stage.should_recieve(:load).with("Testing")
  #      GameMaster::ConfigLoader.register_stage(stage)
  #    end
  #    $subject.load({},{},{})
  #  end
  end

end
