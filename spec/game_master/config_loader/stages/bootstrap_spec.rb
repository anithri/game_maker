require 'spec_helper'

describe GameMaster::ConfigLoader::Stages::Bootstrap do
  subject {GameMaster::ConfigLoader::Stages::Bootstrap}
  let(:game_opts){{}}
  let(:loader_opts){{}}
  let(:runtime_opts){{boot:{all_stages: [subject]},stages: []}}
  let(:config){GameMaster::Config.new(game_opts,loader_opts,runtime_opts)}
  let(:do_stage_load){subject.load(config)}


  context "When passed a filename" do
    let(:loader_opts){{filename: TEST_GAME_CONFIG_FILE}}
    it{do_stage_load.boot.stage.first_stage.arg_type.should eq :filename}
    it{do_stage_load.boot.stage.first_stage.data.should eq TEST_GAME_CONFIG_FILE}
    it{do_stage_load.boot.stage.first_stage.success.should be_true}
    it{do_stage_load.loader.game_dir eq TEST_GAME_DIR}
    it{do_stage_load.loader.game_config_file eq TEST_GAME_CONFIG_FILE}
  end

  context "When passed a dirname" do
    let(:loader_opts){{dirname: TEST_GAME_DIR}}
    it{do_stage_load.boot.stage.first_stage.arg_type.should eq :dirname}
    it{do_stage_load.boot.stage.first_stage.data.should eq TEST_GAME_DIR}
    it{do_stage_load.boot.stage.first_stage.success.should be_true}
    it{do_stage_load.loader.game_dir eq TEST_GAME_DIR}
    it{do_stage_load.loader.game_config_file eq TEST_GAME_CONFIG_FILE}
  end

end