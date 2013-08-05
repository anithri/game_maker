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
    shared_examples "a game_maker_class" do
      it{do_load.loader.game_maker_class.should eq final_class}
      it{do_load.boot.stage.normalize_game_maker_class.success.should be_true}
    end
    shared_examples "a game_maker error raiser" do
      it{expect{do_load}.to raise_error GameParseError, /^Couldn't find class/}
    end

    context "with no game_maker_class defined" do
      let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame}}
      it_behaves_like "a game_maker_class"
    end
    context "with game_maker_class defined as false" do
      let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame, game_maker_class: false}}
      it_behaves_like "a game_maker_class"
    end
    context "with game_maker_class defined as nil" do
      let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame, game_maker_class: nil}}
      it_behaves_like "a game_maker_class"
    end
    context "with game_maker_class defined as ''" do
      let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame, game_maker_class: ''}}
      it_behaves_like "a game_maker error raiser"
    end
    context "with game_maker_class defined as 'game_maker'" do
      let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame, game_maker_class: 'game_maker'}}
      it_behaves_like "a game_maker_class"
    end
    context "with game_maker_class defined as 'Game Maker'" do
      let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame, game_maker_class: 'Game Maker'}}
      it_behaves_like "a game_maker_class"
    end
    context "with game_maker_class defined as 'GameMaker'" do
      let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame, game_maker_class: 'GameMaker'}}
      it_behaves_like "a game_maker_class"
    end
    context "with game_maker_class defined as 'GameMakerFake'" do
      let(:loader_opts){{game_class: TestGame::Game, game_module: TestGame, game_maker_class: 'GameMakerFake'}}
      it_behaves_like "a game_maker error raiser"
    end
    context "with TestGameSpecial used" do
      let(:loader_opts){{game_class: TestGameSpecial::MyGame, game_module: TestGameSpecial}}
      let(:final_class){TestGameSpecial::MyGameMaker}
      it_behaves_like "a game_maker_class"

    end


  end
end
