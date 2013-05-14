require "spec_helper"

describe GameMaker::ConfigLoader do
  subject { GameMaker::ConfigLoader }

  describe ".load" do
    before(:all) do
      @good_yaml_string = "---\n:foo: 123\n:bar: hi\n:baz:\n  :tee: hey\n  :vee: there\n"
      @string_io = ::StringIO.new(@good_yaml_string)
      @file_name = File.dirname(__FILE__) + "/../support/test_read.yml"
      @loader = GameMaker::ConfigLoader
    end

    context "when passed an IO object" do
      before(:each) do
        @string_io.rewind
      end
      it {@loader.load(@string_io).should be_a ::Hashery::OpenCascade}
      it {@loader.load(@string_io).foo.should eq 123}
      it {@loader.load(@string_io).bar.should eq "hi"}
      it {@loader.load(@string_io).baz.tee.should eq "hey"}
      it {@loader.load(@string_io).baz.vee.should eq "there"}
    end

    context "when passed string" do
      before :all do
        @good_cascade = @loader.load(@file_name)
      end
      it {@good_cascade.should be_a ::Hashery::OpenCascade}
      it {@good_cascade.foo.should eq 123}
      it {@good_cascade.bar.should eq "hi"}
      it {@good_cascade.baz.tee.should eq "hey"}
      it {@good_cascade.baz.vee.should eq "there"}
    end

    context "when passed a string that is not a file name or yaml" do
      let(:read_from_bad_filename) do
        subject.load("nofile_like_it_anywhere.yml")
      end
      it "should raise an exception" do
        expect{read_from_bad_filename}.to raise_error GameParseError
      end
    end
  end
end