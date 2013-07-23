require "spec_helper"

describe GameMaster do
  subject { GameMaster }

end

__END__

describe GameMaster do
  subject { GameMaster }
  let(:no_filename_error){[GameParseError, /^No such file exists/]}
  let(:no_dirname_error){[GameParseError, /^No dir found/]}
  let(:no_game_dir_error){[GameParseError, /^Could not determine :game_dir$/]}
  let(:no_module_error){[GameParseError, /^game_module could not be found/]}
  let(:no_class_error){[GameParseError, /^game_class could not be found/]}

  describe ".game_from" do
    shared_examples "a game object" do
      it "and a game object" do
        game.should be_a_kind_of GameMaster::Base
        game.config.has_key?(:game_dir)    .should be_true
        game.config.game_name?   .should be_true
        game.config.game_module? .should be_true
        game.config.game_class?  .should be_true
      end
    end

    context "when passed an dirname" do
      it_should_behave_like "a game object" do
        let(:game){subject.game_from(dirname: TEST_GAME_DIR)}
      end
    end

    #context "when passed an IO object" do
    #  it_should_behave_like "a game object" do
    #    let(:game){subject.game_from(io: ::StringIO.new(TEST_GAME_YAML_STRING),
    #                                 game_dir: TEST_GAME_DIR,
    #                                 game_name: "TestingGame")}
    #  end
    #end

    context "when passed filename" do
      it_should_behave_like "a game object" do
        let(:game){subject.game_from(filename: TEST_GAME_CONFIG_FILE)}
      end
    end

    #context "when passed yaml string" do
    #  it_should_behave_like "a game object" do
    #    let(:game){subject.game_from(yaml_string: TEST_GAME_YAML_STRING,
    #                                 game_dir: TEST_GAME_DIR,
    #                                 game_name: "TestingGame")}
    #  end
    #end

    context "when passed a string that is not a file name" do
      let(:read_from_bad_filename) do
        subject.game_from(filename: "nofile_like_it_anywhere.yml")
      end
      it "should raise an exception" do
        expect{read_from_bad_filename}.to raise_error *no_filename_error
      end
    end

    context "when passed data that does not include a game_dir" do
      it "should be false" do
        binding.pry
        subject.game_from(yaml_string: "---\n:test: 123").config.game_dir.should be_false
      end
    end

    context "when passed data includes a nonexistant game_dir" do
      it "should raise an error" do
        yaml = "---\n:game_dir: /some/none/directory"
        expect{subject.game_from(yaml_string: yaml)}.to raise_error *no_dirname_error
      end
    end

    context "when passed data that includes nonexistant module name" do
      it "should raise an error" do
        yaml = "---\n:game_dir: #{TEST_GAME_DIR}\n:game_module: SomeModule\n"
        expect{subject.game_from(yaml_string: yaml)}.to raise_error *no_module_error
      end
    end

    context "when passed data that includes nonexistant class name" do
      it "should raise an error" do
        yaml = "---\n:game_dir: #{TEST_GAME_DIR}\n:game_class: SomeClass\n:game_module: TestGame\n"
        expect{subject.game_from(yaml_string: yaml)}.to raise_error *no_class_error
      end
    end
  end
end