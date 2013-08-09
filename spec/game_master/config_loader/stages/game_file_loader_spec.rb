require 'spec_helper'

describe GameMaster::ConfigLoader::Stages::GameFileLoader do
  subject{GameMaster::ConfigLoader::Stages::GameFileLoader}

  let(:files){loader.find_game_files(TEST_GAME_DIR)}
  let(:game_opts){{}}
  let(:loader_opts){{game_dir: TEST_GAME_DIR}}
  let(:runtime_opts){{boot:{all_stages: [subject]},stages: []}}
  let(:config){GameMaster::Config.new(game_opts,loader_opts,runtime_opts)}
  let(:loader){subject.new(config)}
  let(:do_load){loader.load}

  describe "#find_game_files(parent_dir" do
    it{files.map{|f| f.basename.to_s}.should eq ["game_config.yml", "b.yaml", "c.yaml", "d.yml"]}
  end

  describe "#scan_dirs" do
    it{loader.scan_dirs.should eq [TEST_GAME_DIR]}
  end

  describe "#parent_keys(parent_dir,game_file)" do
    it{loader.parent_keys(TEST_GAME_DIR, files[0]).should eq []}
    it{loader.parent_keys(TEST_GAME_DIR, files[1]).should eq []}
    it{loader.parent_keys(TEST_GAME_DIR, files[2]).should eq [:a]}
    it{loader.parent_keys(TEST_GAME_DIR, files[3]).should eq [:a,:foo]}
  end

end