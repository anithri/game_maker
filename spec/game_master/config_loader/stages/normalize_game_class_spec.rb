require 'spec_helper'

describe GameMaster::ConfigLoader::Stages::NormalizeGameClass  do
  subject { GameMaster::ConfigLoader::Stages::NormalizeGameClass }

  let(:game_opts){{}}
  let(:loader_opts){{}}
  let(:runtime_opts){{boot:{all_stages: [subject]},stages: []}}
  let(:config){GameMaster::Config.new(game_opts,loader_opts,runtime_opts)}
  let(:do_load){subject.load(config)}

  context ".load" do
    let(:final_class){TestGame::Game}
    shared_examples "a game_class" do
      it{do_load.loader.game_class.should eq final_class}
      it{do_load.boot.stage.normalize_game_class.success.should be_true}
    end
    shared_examples "an game_class error raiser" do
      it{expect{do_load}.to raise_error GameParseError, /^Couldn't find class/}
    end

    context "with game_class defined false" do
      let(:loader_opts){{game_class: false, game_module: TestGame}}
      let(:final_class){TestGame::Game}
      it_behaves_like "a game_class"
    end
    context "with game_class defined nil" do
      let(:loader_opts){{game_class: nil, game_module: TestGame}}
      let(:final_class){TestGame::Game}
      it_behaves_like "a game_class"
    end
    context "with game_class defined 'game'" do
      let(:loader_opts){{game_class: 'game', game_module: TestGame}}
      it_behaves_like "a game_class"
    end
    context "with game_class defined 'Game'" do
      let(:loader_opts){{game_class: 'Game', game_module: TestGame}}
      it_behaves_like "a game_class"
    end
    context "with game_class that doesn't exist" do
      let(:loader_opts){{game_class: 'test_game_stuff',game_module: TestGame}}
      it_behaves_like "an game_class error raiser"
    end

  end
end
