require "spec_helper"

describe GameMaster::Utils do
  subject{GameMaster::Utils}
  let(:mod){Class.new{include GameMaster::Utils}.new}

  describe ".module_exists?" do
    it "should return false if module does not exist" do
      mod.module_exists?("A::B::C").should be_false
    end

    it "should return the Module if module exists" do
      mod.module_exists?("GameMaster::Utils").should eq subject
    end
  end

  describe ".find_module" do
    it "should return the first module listed that exists" do
      mod.find_module("A::B::C","String","D::E::F").should eq String
    end

    it "should return nil if no module is found in list" do
      mod.find_module("A::B::C","D::E::F", "G::H::I").should be_nil
    end
  end

  describe ".name_from_file" do
    it "should return the name of the file without extension or directory" do
      mod.name_from_file("abc.yml").should eq "abc"
      mod.name_from_file("abc.yaml").should eq "abc"
      mod.name_from_file("etc/abc.yml").should eq "abc"

    end
  end

end
