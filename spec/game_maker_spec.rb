require "spec_helper"

describe GameMaker do
  subject { GameMaker }

  describe ".mk_game" do
    before(:all) do
      @good_yaml_string = "---\n:foo: 123\n:bar: hi\n:baz:\n  :tee: hey\n  :vee: there\n"
      @string_io = ::StringIO.new(@good_yaml_string)
      @file_name =  __dir__ + "/support/test_read.yml"
    end

    shared_examples "a game object" do
      it "should return a game object" do
        game.should be_a Hashery::OpenCascade
      end
    end

    context "when passed an IO object" do
      it_should_behave_like "a game object" do
        let(:game){subject.mk_game(@string_io)}
      end
    end

    context "when passed string filename" do
      it_should_behave_like "a game object" do
        let(:game){subject.mk_game(@file_name)}
      end
    end

    context "when passed string as YAML" do
      it_should_behave_like "a game object" do
        let(:game){subject.mk_game(@good_yaml_string)}
      end
    end

    context "when passed a string that is not a file name" do
      let(:read_from_bad_filename) do
        subject.mk_game("nofile_like_it_anywhere.yml")
      end
      it "should raise an exception" do
        expect{read_from_bad_filename}.to raise_error GameParseError
      end
    end
  end
end