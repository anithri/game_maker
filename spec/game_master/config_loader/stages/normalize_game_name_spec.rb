require 'spec_helper'

describe GameMaster::ConfigLoader::Stages::NormalizeGameName do
  subject { GameMaster::ConfigLoader::Stages::NormalizeGameName }

  let(:game_opts){{}}
  let(:loader_opts){{}}
  let(:runtime_opts){{boot:{all_stages: [subject]},stages: []}}
  let(:config){GameMaster::Config.new(game_opts,loader_opts,runtime_opts)}
  let(:do_load){subject.load(config)}

  context ".load" do
    let(:final_name){"Test Game"}
    shared_examples "a game_name" do
      it{do_load.loader.game_name.should eq final_name}
      it{do_load.boot.stage.second_stage.success.should be_true}
    end

    context "returns a false value" do
      let(:final_name){false}
      context "with no game_name defined" do
        it_behaves_like "a game_name"
      end
      context "with game_name defined false" do
        let(:loader_opts){{game_name: false}}
        it_behaves_like "a game_name"
      end
      context "with game_name defined nil" do
        let(:loader_opts){{game_name: nil}}
        it_behaves_like "a game_name"
      end
      context "with game_name defined ''" do
        let(:loader_opts){{game_name: ''}}
        it_behaves_like "a game_name"
      end
    end
    context "returns a name" do
      context "with game_name defined 'test_game'" do
        let(:loader_opts){{game_name: 'test_game'}}
        it_behaves_like "a game_name"
      end
      context "with game_name defined 'test game'" do
        let(:loader_opts){{game_name: 'test game'}}
        it_behaves_like "a game_name"
      end
      context "with game_name defined 'Test Game'" do
        let(:loader_opts){{game_name: 'Test Game'}}
        it_behaves_like "a game_name"
      end
      context "with game_name defined 'TestGame'" do
        let(:loader_opts){{game_name: 'TestGame'}}
        it_behaves_like "a game_name"
      end
      context "with game_name defined TestGame" do
        let(:loader_opts){{game_name: TestGame}}
        it_behaves_like "a game_name"
      end
      context "when given only a game_dir" do
        let(:loader_opts){{game_dir: TEST_GAME_DIR}}
        it_behaves_like "a game_name"
      end
    end
  end
end