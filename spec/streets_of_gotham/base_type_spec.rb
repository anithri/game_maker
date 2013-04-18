require "spec_helper"

describe StreetsOfGotham::BaseType, focus: true do
  subject { StreetsOfGotham::BaseType }

  describe "Class Accessors" do
    it{subject.children.should eq Hash.new}
    it{subject.fields.should eq Hash.new}
  end

  describe "#add_children" do
    after(:each) { subject.children = {} }
    it{subject.should respond_to :add_children}

    context "add a single child" do
      context "via symbol" do
        before(:each){subject.add_children :string}
        it{subject.children.should have_key(:string)}
      end

      context "via string" do
        before(:each){subject.add_children "string"}
        it{subject.children.should have_key(:string)}
      end

      context "via Class" do
        before(:each){subject.add_children String}
        it{subject.children.should have_key(:string)}
      end
    end

    context "add multiple children" do
      context "via symbol" do
        before(:each){subject.add_children :string, :integer}
        it{subject.children.should have_key(:string)}
        it{subject.children.should have_key(:integer)}
      end

      context "via String" do
        before(:each){subject.add_children "string", "integer"}
        it{subject.children.should have_key(:string)}
        it{subject.children.should have_key(:integer)}
      end


      context "via Class" do
        before(:each){subject.add_children String, Integer}
        it{subject.children.should have_key(:string)}
        it{subject.children.should have_key(:integer)}
      end

      context "mixed" do
        before(:each){subject.add_children :string, Integer}
        it{subject.children.should have_key(:string)}
        it{subject.children.should have_key(:integer)}
      end
    end
  end

  describe "#define_children" do
    after(:each) { subject.children = {} }
    context "add a single child via symbol/class" do
      before(:each) {subject.define_children(woot: String)}
      it{subject.children.should have_key(:woot)}
      it{subject.children.fetch(:woot).should eq String}
    end

    context "add a single child via string/class" do
      before(:each) {subject.define_children("woot" => String)}
      it{subject.children.should have_key(:woot)}
      it{subject.children.fetch(:woot).should eq String}
    end
    context "add a single child via string/class" do
      before(:each) {subject.define_children("woot" => String)}
      it{subject.children.should have_key(:woot)}
      it{subject.children.fetch(:woot).should eq String}
    end
    context "add a single child via string/class" do
      before(:each) {subject.define_children("woot" => String)}
      it{subject.children.should have_key(:woot)}
      it{subject.children.fetch(:woot).should eq String}
    end
  end
end
