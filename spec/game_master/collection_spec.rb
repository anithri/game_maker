require "spec_helper"

describe GameMaster::Collection do
  subject{GameMaster::Collection}
  describe "#initializer" do
    let(:collection) {subject.new(:test, String,[])}
    it{collection.should be_a subject}
    it{collection.name.should eq :test}
    it{collection.type.should eq String}
    it{collection.to_ary.should eq []}
    it{collection.opts.should == {}}
  end

  describe ".add_child" do
    let(:collection) do
      test_obj = subject.new(:test, String, ["GameMaster"])
      test_obj.add_child("Greetings")
      test_obj
    end

    context "with no options set" do
      it "should log an info msg" do
        Yell['GameMaster'].should_receive(:info).with(/New collection defined/).ordered
        Yell['GameMaster'].should_receive(:info).with(/added to collection/).ordered
        collection
      end
      it "should raise an ArgumentError" do
        Yell['GameMaster'].should_receive(:error).with(/failed adding member/)
        expect{collection.add_child(42)}.to raise_error ArgumentError
      end
    end

    context "with opts[:ignore_type] set to true" do
      let(:collection) do
        subject.new(:test, String, ["GameMaster"], ignore_type: true)
      end
      it "should return the new value" do
        Yell['GameMaster'].should_receive(:info).twice
        collection.add_child(123)
      end
    end

    context "with opts[:warn_only] set to true" do
      let(:collection) do
        subject.new(:test, String, ["GameMaster"], warn_only: true)
      end
      it "should log a warning" do
        Yell['GameMaster'].should_receive(:info).ordered
        Yell['GameMaster'].should_receive(:warn).ordered
        collection.add_child(123).should eq []
      end
    end

  end

  describe ".full_name" do
    let(:collection) {subject.new(:test, String, ["GameMaster"])}
    it{collection.full_name.should eq "GameMaster::Test"}
  end
  
  describe ".to_ary" do
    let(:collection) {subject.new(:test, String, ["GameMaster"])}

  end
  
  describe ".set_parents" do
    let(:collection){subject.new(:test, String)}
    it{collection.parents.should eq []}
    it "should return right array" do
      collection.set_parents(nil)
      collection.parents.should eq []
    end

    it "should return right array" do
      collection.set_parents("abc_d")
      collection.parents.should eq ["abc_d"]
    end

    it "should return right array" do
      collection.set_parents(:abc_d)
      collection.parents.should eq [:abc_d]
    end
    
  end
end