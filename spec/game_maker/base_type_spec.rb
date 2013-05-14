require "spec_helper"

describe StreetsOfGotham::BaseType do
  subject { StreetsOfGotham::BaseType }
  before(:all){subject.reset!}

  context "Private Methods" do
    it{subject.send(:class_for, String).should eq String}
    it{subject.send(:class_for, :string).should eq String}
    it{subject.send(:class_for, "string").should eq String}
    it{subject.send(:class_for, subject).should eq subject}
    it{subject.send(:class_for, :base_type).should eq subject}
    it{subject.send(:class_for, "base_type").should eq subject}
    it{subject.send(:class_for, "BaseType").should eq subject}
  end

  describe "Class Accessors" do
    after(:each) {subject.reset!}
    it{subject.children.should eq Hash.new}
    it{subject.fields.should eq Hash.new}
  end

  describe "accessors" do
    before(:all){subject.define_fields(name: String, code: Integer)}
    it{subject.instance_methods.should include(:name)}
    it{subject.instance_methods.should include(:name=)}
    it{subject.instance_methods.should include(:code)}
    it{subject.instance_methods.should include(:code=)}
  end

  describe "#add_children" do
    after(:each) { subject.reset! }
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

    context "Add a single child" do
      context "via a symbol key" do
        context "and a value of class" do
          before(:each) {subject.define_children(woot: String)}
          it{subject.children.should have_key(:woot)}
          it{subject.children.fetch(:woot).should eq String}
        end
    
        context "and a value of symbol" do
          before(:each) {subject.define_children(woot: :string)}
          it{subject.children.should have_key :woot}
          it{subject.children.fetch(:woot).should eq String}
        end

        context "and a value of string" do
          before(:each) {subject.define_children(woot: "String")}
          it{subject.children.should have_key :woot}
          it{subject.children.fetch(:woot).should eq String}
        end
      end

      context "via a String key" do
        context "and a value of class"  do
          before(:each) {subject.define_children("woot" => String)}
          it{subject.children.should have_key :woot}
          it{subject.children.fetch(:woot).should eq String}
        end

        context "and a value of symbol" do
          before(:each) {subject.define_children("woot" => :string)}
          it{subject.children.should have_key :woot}
          it{subject.children.fetch(:woot).should eq String}
        end

        context "and a value of string" do
          before(:each) {subject.define_children("woot" => "String")}
          it{subject.children.should have_key :woot}
          it{subject.children.fetch(:woot).should eq String}
        end
      end
    end
    context "Add multiple children" do
      context "via symbol keys" do
        context "and values of class" do
          before(:each) {subject.define_children(woot: String, shiny: Array)}
          it{subject.children.should have_key(:woot)}
          it{subject.children.fetch(:woot).should eq String}
          it{subject.children.should have_key(:shiny)}
          it{subject.children.fetch(:shiny).should eq Array}
        end
        context "and values of symbol" do
          before(:each) {subject.define_children(woot: :string, shiny: Array)}
          it{subject.children.should have_key(:woot)}
          it{subject.children.fetch(:woot).should eq String}
          it{subject.children.should have_key(:shiny)}
          it{subject.children.fetch(:shiny).should eq Array}
        end
        context "and values of string" do
          before(:each) {subject.define_children(woot: "String", 
                                                 shiny: "Array")}
          it{subject.children.should have_key(:woot)}
          it{subject.children.fetch(:woot).should eq String}
          it{subject.children.should have_key(:shiny)}
          it{subject.children.fetch(:shiny).should eq Array}
        end
      end

      context "via String keys" do
        context "and values of class"  do
          before(:each) {subject.define_children("woot" => String, 
                                                 "shiny" => Array)}
          it{subject.children.should have_key(:woot)}
          it{subject.children.fetch(:woot).should eq String}
          it{subject.children.should have_key(:shiny)}
          it{subject.children.fetch(:shiny).should eq Array}
        end
        context "and values of symbol" do
          before(:each) {subject.define_children("woot" => :string,
                                                 "shiny" => :array)}
          it{subject.children.should have_key(:woot)}
          it{subject.children.fetch(:woot).should eq String}
          it{subject.children.should have_key(:shiny)}
          it{subject.children.fetch(:shiny).should eq Array}
        end
        context "and values of string" do
          before(:each) {subject.define_children("woot" => "String",
                                                 "shiny" => "Array")}
          it{subject.children.should have_key(:woot)}
          it{subject.children.fetch(:woot).should eq String}
          it{subject.children.should have_key(:shiny)}
          it{subject.children.fetch(:shiny).should eq Array}
        end
      end
    end
  end

  define "#add_fields" do
    context "add a single field" do
      after(:each) {subject.reset!}
      context "with a class" do
        before(:each) {subject.add_fields(String)}
        it{subject.children.should have_key(:string)}
        it{subject.children.fetch(:string).should eq String}
      end
      context "with a symbol" do
        before(:each) {subject.add_fields(:string)}
        it{subject.children.should have_key(:string)}
        it{subject.children.fetch(:string).should eq String}
      end
      context "with a string" do
        before(:each) {subject.add_fields("String")}
        it{subject.children.should have_key(:string)}
        it{subject.children.fetch(:string).should eq String}
      end
    end
    context "add multiple fields" do
      after(:each) {subject.reset!}
      context "with classes" do
        before(:each) {subject.add_fields(String, Array)}
        it{subject.children.should have_key(:string)}
        it{subject.children.fetch(:string).should eq String}
        it{subject.children.should have_key(:array)}
        it{subject.children.fetch(:array).should eq Array}
      end
      context "with symbols" do
        before(:each) {subject.add_fields(:string, :array)}
        it{subject.children.should have_key(:string)}
        it{subject.children.fetch(:string).should eq String}
        it{subject.children.should have_key(:array)}
        it{subject.children.fetch(:array).should eq Array}
      end
      context "with strings" do
        before(:each) {subject.add_fields("String", "Array")}
        it{subject.children.should have_key(:string)}
        it{subject.children.fetch(:string).should eq String}
        it{subject.children.should have_key(:array)}
        it{subject.children.fetch(:array).should eq Array}
      end
      context "with mixed values" do
        before(:each) {subject.add_fields("String", Array, :hash)}
        it{subject.children.should have_key(:string)}
        it{subject.children.fetch(:string).should eq String}
        it{subject.children.should have_key(:array)}
        it{subject.children.fetch(:array).should eq Array}
        it{subject.children.should have_key(:hash)}
        it{subject.children.fetch(:hash).should eq Hash}
      end
    end
  end
  
  describe "#define_fields" do
    after(:each) { subject.fields = {} }

    context "Add a single child" do
      context "via a symbol key" do
        context "and a value of class" do
          before(:each) {subject.define_fields(woot: String)}
          it{subject.fields.should have_key(:woot)}
          it{subject.fields.fetch(:woot).should eq String}
        end
    
        context "and a value of symbol" do
          before(:each) {subject.define_fields(woot: :string)}
          it{subject.fields.should have_key :woot}
          it{subject.fields.fetch(:woot).should eq String}
        end

        context "and a value of string" do
          before(:each) {subject.define_fields(woot: "String")}
          it{subject.fields.should have_key :woot}
          it{subject.fields.fetch(:woot).should eq String}
        end
      end

      context "via a String key" do
        context "and a value of class"  do
          before(:each) {subject.define_fields("woot" => String)}
          it{subject.fields.should have_key :woot}
          it{subject.fields.fetch(:woot).should eq String}
        end

        context "and a value of symbol" do
          before(:each) {subject.define_fields("woot" => :string)}
          it{subject.fields.should have_key :woot}
          it{subject.fields.fetch(:woot).should eq String}
        end

        context "and a value of string" do
          before(:each) {subject.define_fields("woot" => "String")}
          it{subject.fields.should have_key :woot}
          it{subject.fields.fetch(:woot).should eq String}
        end
      end
    end
    context "Add multiple fields" do
      context "via symbol keys" do
        context "and values of class" do
          before(:each) {subject.define_fields(woot: String, shiny: Array)}
          it{subject.fields.should have_key(:woot)}
          it{subject.fields.fetch(:woot).should eq String}
          it{subject.fields.should have_key(:shiny)}
          it{subject.fields.fetch(:shiny).should eq Array}
        end
        context "and values of symbol" do
          before(:each) {subject.define_fields(woot: :string, shiny: Array)}
          it{subject.fields.should have_key(:woot)}
          it{subject.fields.fetch(:woot).should eq String}
          it{subject.fields.should have_key(:shiny)}
          it{subject.fields.fetch(:shiny).should eq Array}
        end
        context "and values of string" do
          before(:each) {subject.define_fields(woot: "String", 
                                                 shiny: "Array")}
          it{subject.fields.should have_key(:woot)}
          it{subject.fields.fetch(:woot).should eq String}
          it{subject.fields.should have_key(:shiny)}
          it{subject.fields.fetch(:shiny).should eq Array}
        end
      end

      context "via String keys" do
        context "and values of class"  do
          before(:each) {subject.define_fields("woot" => String, 
                                                 "shiny" => Array)}
          it{subject.fields.should have_key(:woot)}
          it{subject.fields.fetch(:woot).should eq String}
          it{subject.fields.should have_key(:shiny)}
          it{subject.fields.fetch(:shiny).should eq Array}
        end
        context "and values of symbol" do
          before(:each) {subject.define_fields("woot" => :string,
                                                 "shiny" => :array)}
          it{subject.fields.should have_key(:woot)}
          it{subject.fields.fetch(:woot).should eq String}
          it{subject.fields.should have_key(:shiny)}
          it{subject.fields.fetch(:shiny).should eq Array}
        end
        context "and values of string" do
          before(:each) {subject.define_fields("woot" => "String",
                                                 "shiny" => "Array")}
          it{subject.fields.should have_key(:woot)}
          it{subject.fields.fetch(:woot).should eq String}
          it{subject.fields.should have_key(:shiny)}
          it{subject.fields.fetch(:shiny).should eq Array}
        end
      end
    end
  end

  describe "#valid?" do
    context "with only simple fields" do
      before(:all) do
        subject.add_fields(:last_name, :first_name)

      end
      after(:all){subject.reset!}
      it{subject.valid?({last_name: "Wayne", first_name: "Bruce"}).should be_true}
      it{subject.valid?({last_name: "Wayne"}).should be_false}
      it{subject.valid?({first_name: "Bruce"}).should be_false}
    end
    context "with complex fields" do
      before(:each) do
        subject.define_fields(last_name: String, first_name: String)
      end
      after(:all){subject.reset!}
      it{subject.valid?({last_name: "Wayne", first_name: "Bruce"}).should be_true}
      it{subject.valid?({last_name: "Wayne", first_name: 1}).should be_false}
      it{subject.valid?({last_name: :Wayne, first_name: "Bruce"}).should
      be_false}
    end
    context "with only simple Children" do
      before(:each) do
        subject.add_children(:last_name, :first_name)
      end
      after(:each){subject.reset!}
      it{subject.valid?({last_name: ["Wayne"], first_name: ["Bruce"]}).should be_true}
      it{subject.valid?({last_name: "Wayne"}).should be_false}
      it{subject.valid?({first_name: "Bruce"}).should be_false}
    end
    #TODO more complex fields require validation
    #context "with complex fields" do
    #  before(:each) do
    #    subject.define_fields(last_name: String, first_name: String)
    #    @valid_hash = {last_name: "Wayne", first_name: "Bruce"}
    #  end
    #  it{subject.valid?(@valid_hash).should be_true}
    #  it{subject.valid?({last_name: "Wayne", first_name: 1}).should be_false}
    #  it{subject.valid?({last_name: :Wayne, first_name: "Bruce"}).should
    #  be_false}
    #end

  end
end
