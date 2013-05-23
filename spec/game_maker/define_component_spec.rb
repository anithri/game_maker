require "spec_helper"

describe GameMaker::DefineComponent do
  subject {GameMaker::DefineComponent}

  describe "#initialize" do
    it "should return an object with this class" do
      subject.new("a","b","c", skip_validations: true, skip_defaults: true).should be_a subject
    end

    it "should have accessors" do
      dc = subject.new("a","b","c", skip_validations: true, skip_defaults: true)
      dc.orig_def.should eq "a"
      dc.game_dir.should eq "b"
      dc.game_module.should eq "c"
    end

    context "when given a name" do
      it "will call .from_name" do
        dc = subject.new("abc","b","c", skip_validations: true, skip_defaults: true)
        dc.definition_method.should eq :from_name
      end
      it "will assign values based on the name" do
        dc = subject.new("abc","b","c", skip_validations: true, skip_defaults: true)
        dc.name.should eq "abc"
        dc.config_file.should eq "etc/abc.yml"
        dc.class_name.should eq "Abc"
        dc.maker_module_name.should eq "AbcMaker"
      end
    end

    context "when given a hash" do
      it "will call .from_name" do
        dc = subject.new({},"b","c", skip_validations: true, skip_defaults: true)
        dc.definition_method.should eq :from_hash
      end
      it "will assign values based on the hash" do
        h = {name: "abc", config_file: "etc/abc.yml", class_name: "Abc", maker_module_name: "AbcMaker"}
        dc = subject.new(h,"b","c", skip_validations: true, skip_defaults: true)
        dc.name.should eq "abc"
        dc.config_file.should eq "etc/abc.yml"
        dc.class_name.should eq "Abc"
        dc.maker_module_name.should eq "AbcMaker"
      end
    end

    context "when given a filename" do
      it "will call .from_file" do
        File.stub(:exists?).and_return true
        dc = subject.new("etc/abc.yml","b","c", skip_validations: true, skip_defaults: true)
        dc.definition_method.should eq :from_file
      end
      it "will assign values based on the filename" do
        File.stub(:exists?).and_return true
        dc = subject.new("etc/abc.yml","b","c", skip_validations: true, skip_defaults: true)
        dc.name.should eq "abc"
        dc.config_file.should eq "etc/abc.yml"
        dc.class_name.should eq "Abc"
        dc.maker_module_name.should eq "AbcMaker"
      end
    end


  end

  describe "#definition" do
    it "should return a Hash" do
      subject.new("a","b","c", skip_defaults: true, skip_validations: true).definition.should be_a Hash
    end
  end


end