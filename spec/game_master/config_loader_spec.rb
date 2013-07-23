require "spec_helper"

describe GameMaster::ConfigLoader do
  subject { GameMaster::ConfigLoader }

end


__END__
describe GameMaster::ConfigLoader do
  subject { GameMaster::ConfigLoader }
  let(:no_filename_error){[GameParseError, /^No such file exists/]}
  let(:no_dirname_error){[GameParseError, /^No dir found/]}

  shared_examples "a config object" do
    it {config.should be_a Hash}
    it {config[:game][:foo].should eq 123}
    it {config[:game][:bar].should eq "hi"}
    it {config[:game][:baz][:tee].should eq "hey"}
    it {config[:game][:baz][:vee].should eq "there"}
  end

  describe ".load_from_file" do
    it_should_behave_like "a config object" do
      let(:config){subject.load_from_file(TEST_GAME_CONFIG_FILE)}
    end
    it "should raise an exception if given a bad filename" do
      expect{subject.load_from_file("no_such_filename.yml")}.to raise_error *no_filename_error
    end
  end

  describe ".load_from_dir" do
    it_should_behave_like "a config object" do
      let(:config){subject.load_from_dir(TEST_GAME_DIR)}
    end
    it "should raise an exception if given a bad dirname" do
      expect{subject.load_from_dir("no_such_dir")}.to raise_error *no_dirname_error
    end
    it "should raise an exception if given a directory with no game_config.yml" do
      expect{subject.load_from_dir(TEST_GAME_DIR + "..")}.to raise_error *no_filename_error
    end

  end

  describe ".load_from_string" do
    it_should_behave_like "a config object" do
      let(:config){subject.load_from_string(TEST_GAME_YAML_STRING)}
    end
  end

  describe ".load_from_io" do
    it_should_behave_like "a config object" do
      let(:config){subject.load_from_io(::StringIO.new(TEST_GAME_YAML_STRING))}
    end
  end

  describe ".load" do
    before(:all) do
      @test_module = GameMaster::ConfigLoader.dup
      [:load_from_file, :load_from_dir, :load_from_string, :load_from_io].each do |loader|
        @test_module.stub(loader)
      end
    end

    it "should call :load_from_file if called with :filename" do
      @test_module.should_receive(:load_from_file)
      @test_module.load(filename: "t.yml")
    end
  end
end