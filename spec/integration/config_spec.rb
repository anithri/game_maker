require 'spec_helper'

__END__
describe GameMaster::Config do
  subject{GameMaster::Config}
  let(:initial_config){{filename: TEST_GAME_CONFIG_FILE}}
  let(:config_obj){GameMaster::Config.new({},initial_config,{},{})}
  let(:first_stage){config_obj.load_first_stage}
  let(:second_stage){first_stage.load_second_stage}
  let(:third_stage){second_stage.load_third_stage;second_stage}
  let(:fourth_stage){third_stage.load_fourth_stage}
  let(:config_from_load){GameMaster::Config.load(initial_config)}

  it{config_obj.should be_a subject}
  it{config_obj.config.filename.should eq TEST_GAME_CONFIG_FILE}

  context "Taken a stage at a time, " do
    context "after first_stage load" do
      it{first_stage.config.game_module.should eq "TestGame"}
      it{first_stage.game.foo.should eq 123}
    end
  
    context "after second_stage_load" do
      it{second_stage.config.game_class.should eq "Game"}
      it{second_stage.config.game_maker_class.should be_false}
    end
  
    context "after third_stage_load" do
      it{third_stage.runtime.game_module.should eq TestGame}
      it{third_stage.runtime.game_class.should eq TestGame::Game}
      it{third_stage.runtime.game_maker_class.should eq TestGame::Game}
    end
  
    context "after fourth_stage_load" do
      it{fourth_stage.game.a.bar.test_two.should eq 2}
      it{fourth_stage.runtime.game_files.keys.should have(2).items}
    end
  end
  
  context "all stages at once, " do
    it{config_from_load.config.game_module.should eq "TestGame"}
    it{config_from_load.game.foo.should eq 123}
    it{config_from_load.config.game_class.should eq "Game"}
    it{config_from_load.config.game_maker_class.should be_false}
    it{config_from_load.runtime.game_module.should eq TestGame}
    it{config_from_load.runtime.game_class.should eq TestGame::Game}
    it{config_from_load.runtime.game_maker_class.should eq TestGame::Game}
    it{config_from_load.game.a.bar.test_two.should eq 2}
    it{config_from_load.runtime.game_files.keys.should have(2).items}
  end
  
end