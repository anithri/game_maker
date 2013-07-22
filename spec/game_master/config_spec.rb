require 'spec_helper'

describe GameMaster::Config, focus: true do
  subject{GameMaster::Config}
  it{subject.new.should be_a subject}
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
      def dir?
        true
      end
    end
    class FakeDir
      def dir?
        false
      end
    end
  end

  describe ".mk_config" do
    let(:test_obj){subject.send(:mk_config,{a: 1, b: 2, c:{foo: :bar}})}
    it{test_obj.should be_a_kind_of Hashery::OpenCascade}
    it{test_obj.keys.should eq [:a,:b,:c]}
    it{test_obj.a.should eq 1}
    it{test_obj.c.should be_a_kind_of Hashery::OpenCascade}
    it{test_obj.c.foo.should eq :bar}
  end

  describe "#set_defaults" do
    let(:test_obj){subject.new({},test_hash).set_defaults}
    context "When passed nothing" do
      let(:test_hash){{}}
      it{test_obj.config.game_dir.should         be_false}
      it{test_obj.config.game_class.should       eq "Game"}
      it{test_obj.config.game_maker_class.should be_false}
    end
    
    describe "When passed a game_dir" do
      let(:test_hash){{game_dir: test_dir}}
      context "as a pathname" do
        let(:test_dir){Pathname.new("/game/dir/woot")}
        it{test_obj.config.game_dir.should eq test_dir}
        it{test_obj.config.game_name.should eq "Woot"}
        it{test_obj.config.game_module.should eq "Woot"}
      end
      context "as a string" do
        let(:test_dir){"/game/dir/woot"}
        it{test_obj.config.game_dir.should eq Pathname.new(test_dir)}
        it{test_obj.config.game_name.should eq "Woot"}
        it{test_obj.config.game_module.should eq "Woot"}
      end
      context "as false" do
        let(:test_dir){false}
        it{test_obj.config.game_dir.should be_false}
        it{test_obj.config.game_name?.should be_false}
      end
      context "as nil" do
        let(:test_dir){nil}
        it{test_obj.config.game_dir.should be_false}
        it{test_obj.config.game_name?.should be_false}
      end
      context "as something that can't be #to_s" do
        let(:test_dir){TestMe.new}

        it "should raise a GameParseError" do
          expect{test_obj.config}.to raise_error GameParseError
        end
      end
    end

    context "When passed a game_module" do
      let(:test_hash){{game_name: "Foo", game_module: "configGame"}}
      it{test_obj.config.game_module.should eq "ConfigGame"}
    end

    context "When passed a game_class" do
      let(:test_hash){{game_name: "Foo",  game_class: "Baz"}}
      it{test_obj.config.game_class.should eq "Baz"}
      it{test_obj.config.game_maker_class.should be_false}
    end

    context "When passed a game_maker_class" do
      let(:test_hash){{game_maker_class: "Baz"}}
      it{test_obj.config.game_class.should eq "Game"}
      it{test_obj.config.game_maker_class.should eq "Baz"}
    end
  end

  describe "#check_game_dir?" do
    let(:test_hash){{game_dir: test_dir}}
    let(:test_obj){subject.new({},test_hash)}
    context "When game_dir is false" do
      let(:test_dir){false}
      it{test_obj.send(:check_game_dir?).should eq :skip}
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
      it{test_obj.send(:check_game_dir?).should eq :dir}
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
        expect{test_obj.send(:check_game_dir?)}.to raise_error GameParseError
      end
    end
  end

  describe "#check_game_module?" do
    let(:test_obj){subject.new({},{game_module: test_module})}
    context "When module exists" do
      let(:test_module){"String"}
      it{test_obj.send(:check_game_module?).should eq String}
    end

    context "when module does not exist" do
      let(:test_module){"NoSuchModule"}
      it "should raise a GameParseError" do
        expect{test_obj.send(:check_game_module?)}.to raise_error GameParseError, /game_module could not be found/
      end
    end
    context "when given entry it can't turn into module name" do
      let(:test_module){class TestClassOne;undef_method(:to_s);end; TestClassOne.new}
      it "should raise a GameParseError" do
        expect{test_obj.send(:check_game_module?)}.to raise_error GameParseError, /game_module could not be determined/
      end
    end
  end

  describe "#check_game_class?" do
    let(:test_obj){subject.new({},{game_module: "TestModule", game_class: test_klass},{},{game_module: TestModule})}
    context "When class exists" do
      let(:test_klass){"Game"}
      it{test_obj.send(:check_game_class?).should eq TestModule::Game}
    end

    context "when class does not exist" do
      let(:test_klass){"NoSuchModule"}
      it "should raise a GameParseError" do
        expect{test_obj.send(:check_game_class?)}.to raise_error GameParseError, /game_class could not be found/
      end
    end

    context "when given entry that it can't turn into module name" do
      let(:test_klass){class TestClassTwo;undef_method(:to_s);end; TestClassTwo.new}
      it "should raise a GameParseError" do
        expect{test_obj.send(:check_game_class?)}.to raise_error GameParseError, /game_class could not be determined/
      end
    end
  end

  describe "#check_game_maker_class?" do
    let(:test_obj) do
      subject.new({},
                  {game_module: "TestModule",game_maker_class: test_klass},
                  {},
                  {game_module: TestModule,game_class: TestModule::Game})
    end

    context "When class is false" do
      let(:test_klass){false}
      it{test_obj.send(:check_game_maker_class?).should eq TestModule::Game}
    end

    context "When class exists" do
      let(:test_klass){"GameMaker"}
      it{test_obj.send(:check_game_maker_class?).should eq TestModule::GameMaker}
    end

    context "when class does not exist" do
      let(:test_klass){"NoSuchModule"}
      it "should raise a GameParseError" do
        expect{test_obj.send(:check_game_maker_class?)}.to raise_error GameParseError, /game_maker_class could not be found/
      end
    end

    context "when given entry that it can't turn into module name" do
      let(:test_klass){123}
      it "should raise a GameParseError" do
        expect{test_obj.send(:check_game_maker_class?)}.to raise_error GameParseError, /game_maker_class could not be determined/
      end
    end
  end
end