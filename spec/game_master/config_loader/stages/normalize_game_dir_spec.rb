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

    context "returns false value" do
      let(:game_dir){false}
      context "when no game_module defined" do
        it_behaves_like "a game_dir"
      end
      context "when game_dir defined false" do
        let(:loader_opts){{game_dir: false}}
        it_behaves_like "a game_dir"
      end
      context "when game_dir defined nil" do
        let(:loader_opts){{game_dir: nil}}
        it_behaves_like "a game_dir"
      end
      context "when game_dir defined ''" do
        let(:loader_opts){{game_dir: ''}}
        it_behaves_like "a game_dir"
      end
    end

    context "returns directory" do
      context "when passed a string (Absolute)" do
        let(:loader_opts){{game_dir: TEST_GAME_DIR.to_s}}
        it_behaves_like "a game_dir"
      end
      context "when passed a string (Absolute)" do
        let(:loader_opts){{game_dir: "spec/support/test_game"}}
        it_behaves_like "a game_dir"
      end
      context "when passed a Pathname (Absolute)" do
        let(:loader_opts){{game_dir: TEST_GAME_DIR}}
        it_behaves_like "a game_dir"
      end
      context "when passed a string (Absolute)" do
        let(:loader_opts){{game_dir: Pathname.new("spec/support/test_game")}}
        it_behaves_like "a game_dir"
      end
    end

    context "raise an error" do
      context "when passed a dir that doesn't exist" do
        let(:loader_opts){{game_dir: 'tmp/test/spec/dir'}}
        it{expect{do_load}.to raise_error GameParseError}
      end
    end
  end
end