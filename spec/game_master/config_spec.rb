require 'spec_helper'

describe GameMaster::Config do
  subject { GameMaster::Config }
  it { subject.new.should be_a subject }
  before(:all) do
    module TestModule
      class One
      end
      class Game
      end
      class GameMaker
      end
    end
    class TestMe
      undef_method :to_s
    end
    class RealDir
      def directory?
        true
      end
    end
    class FakeDir
      def directory?
        false
      end
    end
  end

  describe "#initialize" do
    context "when passed empty hashes" do
      let(:test_obj){subject.new({},{},{},{})}
      it{test_obj.should be_a subject}
      it{test_obj.boot.original_config = {}}
    end
    context "when passed a non-hash" do
      it "should raise an ArgumentError"do
        expect{GameMaster::Config.new([],1,2,3)}.to raise_error ArgumentError
      end
    end
  end

  describe ".mk_config" do
    let(:test_obj) { subject.send(:mk_config, {a: 1, b: 2, c: {foo: :bar }})}
    it { test_obj.should be_a_kind_of Hashery::OpenCascade }
    it { test_obj.keys.should eq [:a, :b, :c] }
    it { test_obj.a.should eq 1 }
    it { test_obj.c.should be_a_kind_of Hashery::OpenCascade }
    it { test_obj.c.foo.should eq :bar }
  end

  describe "#load_second_stage" do
    let(:test_obj) { subject.new({}, test_hash).load_second_stage }
    context "When passed nothing" do
      let(:test_hash) { {} }
      it { test_obj.config.game_dir.should be_false }
      it { test_obj.config.game_class.should eq "Game" }
      it { test_obj.config.game_maker_class.should be_false }
    end

    context "When passed a game_dir" do
      let(:test_hash) { {game_dir: test_dir }}
      context "as a pathname" do
        let(:test_dir) { Pathname.new("/game/dir/woot") }
        it { test_obj.config.game_dir.should eq test_dir }
        it { test_obj.config.game_name.should eq "Woot" }
        it { test_obj.config.game_module.should eq "Woot" }
      end
      context "as a string" do
        let(:test_dir) { "/game/dir/woot" }
        it { test_obj.config.game_dir.should eq Pathname.new(test_dir) }
        it { test_obj.config.game_name.should eq "Woot" }
        it { test_obj.config.game_module.should eq "Woot" }
      end
      context "as false" do
        let(:test_dir) { false }
        it { test_obj.config.game_dir.should be_false }
        it { test_obj.config.game_name?.should be_false }
      end
      context "as nil" do
        let(:test_dir) { nil }
        it { test_obj.config.game_dir.should be_false }
        it { test_obj.config.game_name?.should be_false }
      end
      context "as something that can't be #to_s" do
        let(:test_dir) { TestMe.new }

        it "should raise a GameParseError" do
          expect { test_obj.config }.to raise_error GameParseError
        end
      end
    end

    context "When passed a game_module" do
      let(:test_hash) { {game_name: "Foo", game_module: "configGame" }}
      it { test_obj.config.game_module.should eq "ConfigGame" }
    end

    context "When passed a game_class" do
      let(:test_hash) { {game_name: "Foo", game_class: "Baz" }}
      it { test_obj.config.game_class.should eq "Baz" }
      it { test_obj.config.game_maker_class.should be_false }
    end

    context "When passed a game_maker_class" do
      let(:test_hash) { {game_maker_class: "Baz" }}
      it { test_obj.config.game_class.should eq "Game" }
      it { test_obj.config.game_maker_class.should eq "Baz" }
    end
  end

  describe "#check_game_dir?" do
    let(:test_hash) { {game_dir: test_dir }}
    let(:test_obj) { subject.new({}, test_hash) }
    context "When game_dir is false" do
      let(:test_dir) { false }
      it { test_obj.send(:check_game_dir?).should eq :skip }
    end
    context "When game_dir is valid" do
      let(:test_dir) do
        class RealDir
          def dir?
            true
          end
        end
        RealDir.new
      end
      it { test_obj.send(:check_game_dir?).should eq :dir }
    end
    context "When game_dir is not valid" do
      let(:test_dir) do
        class FakeDir
          def dir?
            false
          end
        end
        FakeDir.new
      end
      it "should raise a GameParseError" do
        expect { test_obj.send(:check_game_dir?) }.to raise_error GameParseError
      end
    end
  end

  describe "#check_game_module?" do
    let(:test_obj) { subject.new({}, {game_module: test_module })}
    context "When module exists" do
      let(:test_module) { "String" }
      it { test_obj.send(:check_game_module?).should eq String }
    end

    context "when module does not exist" do
      let(:test_module) { "NoSuchModule" }
      it "should raise a GameParseError" do
        expect { test_obj.send(:check_game_module?) }.to raise_error GameParseError, /game_module could not be found/
      end
    end
    context "when given entry it can't turn into module name" do
      let(:test_module) {
        class TestClassOne;
          undef_method(:to_s);
        end; TestClassOne.new }
      it "should raise a GameParseError" do
        expect { test_obj.send(:check_game_module?) }.to raise_error GameParseError, /game_module could not be determined/
      end
    end
  end

  describe "#check_game_class?" do
    let(:test_obj) { subject.new({}, {game_module: "TestModule", game_class: test_klass }, {}, {game_module: TestModule})}
    context "When class exists" do
      let(:test_klass) { "Game" }
      it { test_obj.send(:check_game_class?).should eq TestModule::Game }
    end

    context "when class does not exist" do
      let(:test_klass) { "NoSuchModule" }
      it "should raise a GameParseError" do
        expect { test_obj.send(:check_game_class?) }.to raise_error GameParseError, /game_class could not be found/
      end
    end

    context "when given entry that it can't turn into module name" do
      let(:test_klass) {
        class TestClassTwo;
          undef_method(:to_s);
        end; TestClassTwo.new }
      it "should raise a GameParseError" do
        expect { test_obj.send(:check_game_class?) }.to raise_error GameParseError, /game_class could not be determined/
      end
    end
  end

  describe "#check_game_maker_class?" do
    let(:test_obj) do
      subject.new({},
                  {game_module: "TestModule", game_maker_class: test_klass},
          {},
          {game_module: TestModule, game_class: TestModule::Game})
    end

    context "When class is false" do
      let(:test_klass) { false }
      it { test_obj.send(:check_game_maker_class?).should eq TestModule::Game }
    end

    context "When class exists" do
      let(:test_klass) { "GameMaker" }
      it { test_obj.send(:check_game_maker_class?).should eq TestModule::GameMaker }
    end

    context "when class does not exist" do
      let(:test_klass) { "NoSuchModule" }
      it "should raise a GameParseError" do
        expect { test_obj.send(:check_game_maker_class?) }.to raise_error GameParseError, /game_maker_class could not be found/
      end
    end

    context "when given entry that it can't turn into module name" do
      let(:test_klass) { 123 }
      it "should raise a GameParseError" do
        expect { test_obj.send(:check_game_maker_class?) }.to raise_error GameParseError, /game_maker_class could not be determined/
      end
    end
  end

  describe "#load_dir_structure" do
    let(:test_obj) do
      subject.new({},
                  {game_dir: "/tmp"},
                  {a: {b: {c: 3}}},
                  {}
      )
    end

    context "when given a set of keys that returns a non-hash" do
      it "should raise a GameParseError" do
        expect{test_obj.send(:insert_file, [:a,:b,:c], "test")}.to raise_error GameParseError, /already has a value/
      end
    end

    context "when given a set of keys that returns a hash" do
      it "should merge the contents of file into the hash returned by keys" do
        YAML.stub(load_file: {foo: 123, bar: 456})
        test_obj.send(:insert_file, [:a,:b,:d], "test")
        test_obj.game.a.b.d.foo.should eq 123
        test_obj.game.a.b.d.bar.should eq 456
      end
    end
  end

  describe "#load_dir_structure" do
    let(:test_obj) do
      subject.new({},
                  {game_dir: "."},
                  {a: {b: {c: 3}}},
                  {}
      )
    end
    let(:dir) do
      files = ['one/a.yml','one/b.yaml','one/two/c.yml','a.txt',
               'one/text.log']
      files.map!{|e| Pathname.new(e)}
      files.each{|e| e.stub(:relative_path_from).and_return(e)}
      dirs = ['one/a','one','one/two/c','three']
      dirs.map!{|e| Pathname.new(e)}
      dirs.each{|e| e.stub(directory?: true)}
      stub(find: [files, dirs].flatten.shuffle)
    end

    it{dir.find.should have(9).items}
    it{dir.find.count{|e| e.directory?}.should eq 4}
    it{dir.find.count{|e| ! e.directory?}.should eq 5}
    it{dir.find.count{|e| e.to_s =~ /\.ya?ml$/}.should eq 3}

    context "when passed a false value" do
      it "should just return" do
        test_obj.should_not_receive(:insert_file)
        test_obj.send(:load_dir_structure,false)
      end
    end

    context "when passed a directory" do
      it "should pass only files ending in .yml or .yaml do #insert_file" do
        test_obj.stub(insert_file: true)
        test_obj.should_receive(:insert_file).with([:one],Pathname.new("one/a.yml"))
        test_obj.should_receive(:insert_file).with([:one],Pathname.new("one/b.yaml"))
        test_obj.should_receive(:insert_file).with([:one,:two],Pathname.new("one/two/c.yml"))
        test_obj.send(:load_dir_structure, dir)
      end
    end
  end


end