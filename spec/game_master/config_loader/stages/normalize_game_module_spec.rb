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
      it{do_load.loader.game_module_name.should eq final_module_name}
      it{do_load.loader.game_module.should eq final_module}
      it{do_load.boot.stage.normalize_game_module.success.should be_true}
    end

    context "returns a false value" do

    end

    context "returns a module" do

    end

    context "" do

    end


    context "using name based determination" do
      context "with no game_module_name defined" do
        let(:final_module){false}
        it_behaves_like "a game_module"
      end
      context "with game_module_name defined false" do
        let(:loader_opts){{game_module_name: false}}
        let(:final_module){false}
        it_behaves_like "a game_module"
      end
      context "with game_module_name defined nil" do
        let(:loader_opts){{game_module_name: nil}}
        let(:final_module){false}
        it_behaves_like "a game_module"
      end
      context "with game_module_name defined 'test_game'" do
        let(:loader_opts){{game_module_name: 'test_game'}}
        it_behaves_like "a game_module"
      end
      context "with game_module_name defined 'TestGame'" do
        let(:loader_opts){{game_module_name: 'TestGame'}}
        it_behaves_like "a game_module"
      end
      context "with game_module_name defined TestGame" do
        let(:loader_opts){{game_module_name: TestGame}}
        it_behaves_like "a game_module"
      end
      context "with game_module_name that doesn't exist" do
        let(:loader_opts){{game_module_name: 'test_game_stuff'}}
        it{expect{do_load}.to raise_error GameParseError}
      end
    end
    
    context "using module based determination" do
      context "with game_module defined false" do
        let(:loader_opts){{game_module: false}}
        let(:final_module){false}
        it_behaves_like "a game_module"
      end
      context "with game_module defined nil" do
        let(:loader_opts){{game_module: nil}}
        let(:final_module){false}
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
      context "with game_module that doesn't exist" do
        let(:loader_opts){{game_module: 'test_game_stuff'}}
        it{expect{do_load}.to raise_error GameParseError}
      end
      
    end
    
    context "using game_name based determination" do
      context "with game_name defined false" do
        let(:loader_opts){{game_name: false}}
        let(:final_module){false}
        it_behaves_like "a game_module"
      end
      context "with game_name defined nil" do
        let(:loader_opts){{game_name: nil}}
        let(:final_module){false}
        it_behaves_like "a game_module"
      end
      context "with game_name defined 'test_game'" do
        let(:loader_opts){{game_name: 'test_game'}}
        it_behaves_like "a game_module"
      end
      context "with game_name defined 'TestGame'" do
        let(:loader_opts){{game_name: 'TestGame'}}
        it_behaves_like "a game_module"
      end
      context "with game_name defined TestGame" do
        let(:loader_opts){{game_name: TestGame}}
        it_behaves_like "a game_module"
      end
      context "with game_name that doesn't exist" do
        let(:loader_opts){{game_name: 'test_game_stuff'}}
        it{expect{do_load}.to raise_error GameParseError}
      end
    end
  end
end
