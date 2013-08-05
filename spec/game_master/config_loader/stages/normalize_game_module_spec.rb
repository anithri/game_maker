require 'spec_helper'

describe GameMaster::ConfigLoader::Stages::NormalizeGameModule do
  subject { GameMaster::ConfigLoader::Stages::NormalizeGameModule }

  let(:game_opts){{}}
  let(:loader_opts){{}}
  let(:runtime_opts){{boot:{all_stages: [subject]},stages: []}}
  let(:config){GameMaster::Config.new(game_opts,loader_opts,runtime_opts)}
  let(:do_load){subject.load(config)}

  context ".load" do
    let(:final_module){TestGame}
    let(:final_module_name){final_module ? final_module.to_s : final_module}
    shared_examples "a game_module" do
      it{do_load.loader.game_module.should eq final_module}
      it{do_load.boot.stage.normalize_game_module.success.should be_true}
    end
    shared_examples "an error raiser" do
      it{expect{do_load}.to raise_error GameParseError}
    end

    context "when passed a valid module name" do
      context "depending on game_module" do
        context "with game_module defined 'Test Game'" do
          let(:loader_opts){{game_module: 'Test Game'}}
          it_behaves_like "a game_module"
        end
        context "with game_module defined 'Test game'" do
          let(:loader_opts){{game_module: 'Test game'}}
          it_behaves_like "a game_module"
        end
        context "with game_module defined 'test_game'" do
          let(:loader_opts){{game_module: 'test_game'}}
          it_behaves_like "a game_module"
        end
        context "with game_module defined 'TestGame'" do
          let(:loader_opts){{game_module: 'TestGame'}}
          it_behaves_like "a game_module"
        end
        context "with game_module defined TestGame" do
          let(:loader_opts){{game_module: TestGame}}
          it_behaves_like "a game_module"
        end
      end

      context "depending on game_name" do
        context "with game_name defined 'Test Game'" do
          let(:loader_opts){{game_module: 'Test Game'}}
          it_behaves_like "a game_module"
        end
      end
    end

    context "when passed an invalid module name" do
      context "with no game_module_name defined" do
        it_behaves_like "an error raiser"
      end
      context "with game_module defined false" do
        let(:loader_opts){{game_module: false}}
        it_behaves_like "an error raiser"
      end
      context "with game_module defined nil" do
        let(:loader_opts){{game_module: nil}}
        let(:final_module){false}
        it_behaves_like "an error raiser"
      end
      context "with game_module defined 'some_test_game'" do
        let(:loader_opts){{game_module: 'some_test_game'}}
        it_behaves_like "an error raiser"
      end
      context "with game_module defined 'TestGame'" do
        let(:loader_opts){{game_module: 'AnotherTestGame'}}
        it_behaves_like "an error raiser"
      end
      context "with game_name defined 'TestGame'" do
        let(:loader_opts){{game_name: 'TestGame'}}
        it_behaves_like "a game_module"
      end
      context "with game_name defined TestGame" do
        let(:loader_opts){{game_name: TestGame}}
        it_behaves_like "a game_module"
      end
    end
  end
end
