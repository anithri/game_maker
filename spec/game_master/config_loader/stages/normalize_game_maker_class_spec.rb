require 'spec_helper'

describe GameMaster::ConfigLoader::Stages::NormalizeGameMakerClass do
  subject { GameMaster::ConfigLoader::Stages::NormalizeGameMakerClass }

  let(:game_opts){{}}
  let(:loader_opts){{}}
  let(:runtime_opts){{boot:{all_stages: [subject]},stages: []}}
  let(:config){GameMaster::Config.new(game_opts,loader_opts,runtime_opts)}
  let(:do_load){subject.load(config)}

  context ".load" do
    let(:final_class){TestGame::GameMaker}
    let(:final_class_name){final_class ? "GameMaker" : false}
    shared_examples "a game_maker_class" do
      it{do_load.loader.game_maker_class_name.should eq final_class_name}
      it{binding.pry;do_load.loader.game_maker_class.should eq final_class}
      it{do_load.boot.stage.normalize_game_maker_class.success.should be_true}
    end

    context "using name based determination" do
      context "with no game_maker_class_name defined" do
        let(:final_class){false}
        it_behaves_like "a game_maker_class"
      end
      context "with game_maker_class_name defined false" do
        let(:loader_opts){{game_maker_class_name: false}}
        let(:final_class){false}
        it_behaves_like "a game_maker_class"
      end
      context "with game_maker_class_name defined nil" do
        let(:loader_opts){{game_maker_class_name: nil}}
        let(:final_class){false}
        it_behaves_like "a game_maker_class"
      end
      context "with game_maker_class_name defined ''" do
        let(:loader_opts){{game_maker_class_name: ''}}
        let(:final_class){false}
        it_behaves_like "a game_maker_class"
      end
      context "with game_maker_class_name defined 'test_game'" do
        let(:loader_opts){{game_module: TestGame,game_maker_class_name: 'game_maker'}}
        it_behaves_like "a game_maker_class"
      end
      context "with game_maker_class_name defined 'TestGame'" do
        let(:loader_opts){{game_module: TestGame,game_maker_class_name: 'GameMaker'}}
        it_behaves_like "a game_maker_class"
      end
      context "with game_maker_class_name defined TestGame" do
        let(:loader_opts){{game_module: TestGame,game_maker_class_name: TestGame::Game}}
        it_behaves_like "a game_maker_class"
      end
      context "with game_maker_class_name that doesn't exist" do
        let(:loader_opts){{game_module: TestGame,game_maker_class_name: 'test_game_stuff'}}
        it{expect{do_load}.to raise_error GameParseError}
      end
    end

    context "using class based determination" do
      context "with game_class defined false" do
        let(:loader_opts){{game_class: false, game_module: TestGame}}
        let(:final_class){TestGame::Game}
        it_behaves_like "a game_maker_class"
      end
      context "with game_class defined nil" do
        let(:loader_opts){{game_class: nil, game_module: TestGame}}
        let(:final_class){TestGame::Game}
        it_behaves_like "a game_maker_class"
      end
      context "with game_class defined 'game'" do
        let(:loader_opts){{game_class: 'game', game_module: TestGame}}
        it_behaves_like "a game_maker_class"
      end
      context "with game_class defined 'Game'" do
        let(:loader_opts){{game_class: 'Game', game_module: TestGame}}
        it_behaves_like "a game_maker_class"
      end
      context "with game_class defined TestGame::Game" do
        let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame}}
        it_behaves_like "a game_maker_class"
      end
      context "with game_class that doesn't exist" do
        let(:loader_opts){{game_class: 'test_game_stuff',game_module: TestGame}}
        it{expect{do_load}.to raise_error GameParseError}
      end
    end

    context "using game_module based determination" do
      context "with game_name defined false" do
        let(:loader_opts){{game_module: false}}
        let(:final_class){false}
        it_behaves_like "a game_maker_class"
      end
      context "with game_module defined nil" do
        let(:loader_opts){{game_module: nil}}
        let(:final_class){false}
        it_behaves_like "a game_maker_class"
      end
      context "with game_module defined TestGame", focus: true do
        let(:loader_opts){{game_module: TestGame, game_class: TestGame::Game}}
        it_behaves_like "a game_maker_class"
      end
    end
  end
end
