require 'spec_helper'

describe GameMaster::ConfigLoader::Stages::NormalizeGameDir do
  subject { GameMaster::ConfigLoader::Stages::NormalizeGameDir }

  let(:game_opts){{}}
  let(:loader_opts){{}}
  let(:runtime_opts){{boot:{all_stages: [subject]}}}
  let(:config){GameMaster::Config.new(game_opts,loader_opts,runtime_opts)}
  let(:do_load){subject.load(config)}

  describe "#load" do
    let(:game_dir){TEST_GAME_DIR}
    shared_examples "a game_dir" do
      it{do_load.boot.stage.normalize_game_dir.success?.should be_true}
      it{do_load.boot.stage.normalize_game_dir.success.should be_true}
      it{do_load.loader.game_dir.should eq game_dir}
    end

    context "expects a false value" do
      let(:game_dir){false}
      context "with no game_module defined" do
        it_behaves_like "a game_dir"
      end
      context "with game_module defined false" do
        let(:loader_opts){{game_module: false}}
        it_behaves_like "a game_dir"
      end
      context "with no game_module defined nil" do
        let(:loader_opts){{game_module: nil}}
        it_behaves_like "a game_dir"
      end
      context "with no game_module defined ''" do
        let(:loader_opts){{game_module: ''}}
        it_behaves_like "a game_dir"
      end
    end
  end
end