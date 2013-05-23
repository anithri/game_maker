require "spec_helper"

describe GameMaster::Utils do
  subject{GameMaster::Utils}

  describe ".module_exists?" do
    it "should return false if module does not exist" do
      subject.module_exists?("A::B::C").should be_false
    end

    it "should return the Module if module exists" do
      subject.module_exists?("GameMaster::Utils").should eq subject
    end
  end

  describe ".find_module" do
    it "should return the first module listed that exists" do
      subject.find_module("A::B::C","String","D::E::F").should eq String
    end

    it "should return nil if no module is found in list" do
      subject.find_module("A::B::C","D::E::F", "G::H::I").should be_nil
    end
  end

  describe ".name_from_file" do
    it "should return the name of the file without extension or directory" do
      subject.name_from_file("abc.yml").should eq "abc"
      subject.name_from_file("abc.yaml").should eq "abc"
      subject.name_from_file("etc/abc.yml").should eq "abc"

    end
  end

end
