require 'spec_helper'

describe GameMaster::ConfigLoader::Stages::GameLoader do
  subject{GameMaster::ConfigLoader::Stages::GameLoader}

  let(:game_opts){{}}
  let(:loader_opts){{}}
  let(:runtime_opts){{boot:{all_stages: [subject]},stages: []}}
  let(:config){GameMaster::Config.new(game_opts,loader_opts,runtime_opts)}
  let(:loader){subject.new(config)}
  let(:do_load){loader.load}

  context "#initialize" do
    it{loader.boot.stage.game_loader.scan_dirs?.should eq []}
    it{loader.boot.stage.game_loader.game_files?.should eq []}
    context "when passed a config with scalar setting" do
      let(:loader_opts){{game_dir: Pathname.new(".").expand_path,scan_dirs: '/tmp', game_files: '/dev/null'}}
      it{loader.boot.stage.game_loader.scan_dirs?.should eq [Pathname.new(".").expand_path,Pathname.new('/tmp')]}
      it{loader.boot.stage.game_loader.game_files?.should eq [Pathname.new('/dev/null')]}
    end
    context "when passed a config an array setting" do
      let(:loader_opts){{game_dir: Pathname.new(".").expand_path,scan_dirs: ['/tmp'], game_files: ['/dev/null']}}
      it{loader.boot.stage.game_loader.scan_dirs?.should eq [Pathname.new(".").expand_path,Pathname.new('/tmp')]}
      it{loader.boot.stage.game_loader.game_files?.should eq [Pathname.new('/dev/null')]}
    end


  end

end