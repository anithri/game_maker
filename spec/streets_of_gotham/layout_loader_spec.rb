require "spec_helper"

describe StreetsOfGotham::ConfigLoader do
  subject { StreetsOfGotham::ConfigLoader }
  let(:simple_config){subject.new(Date, ["first_file.yml","second_file.yml"])}

  describe ".initialize" do
    it{simple_config.should be_a subject}
  end

  describe ".by_file" do
    before (:all) do
      ::YAML.stub(:load).and_receive("first_file.yml").and_return("FIRST")
    end
    it {simple_config.by_file("first_file.yml").should eq "FIRST"}

  end
end
