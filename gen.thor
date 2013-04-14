class Gen < Thor::Group
  include Thor::Actions

# Define arguments and options
  argument :name
  class_option :test_framework, :default => :rspec

  def self.source_root
    ENV["PWD"]
  end

  def create_lib_file
    create_file "lib/#{module_name}/#{new_file}.rb" do
      "module #{module_namespace}\n  class #{new_class}\n  end\nend"
    end
  end

  def create_test_file
    test = options[:test_framework].to_s == "rspec" ? :spec : :test
    create_file "#{test}/#{module_name}/#{new_file}_spec.rb" do
      %Q|require "spec_helper"\n\ndescribe #{namespaced_constant} do\n| +
      %Q|  subject { #{namespaced_constant} }\n\n| +
      %Q|  describe "#initialize" do\n| +
      %Q|    pending "write some tests"\n| +
      %Q|  end\nend\n|
    end
  end

  def insert_require
    insert_into_file "lib/#{module_name}.rb", :before => "\nmodule #{module_namespace}" do
      %Q|require "#{module_name}/#{new_file}"\n|
    end
  end

  private
  def module_name
    File.basename(ENV["PWD"])
  end

  def module_namespace
    Thor::Util.camel_case(module_name)
  end

  def new_class
    Thor::Util.camel_case(name)
  end

  def new_file
    Thor::Util.snake_case(name)
  end

  def namespaced_constant
    "#{module_namespace}::#{new_class}"
  end

end
