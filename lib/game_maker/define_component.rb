require 'facets/string/snakecase'
require 'facets/string/camelcase'

module GameMaker
  class DefineComponent
    include GameMaker::Utils

    attr_reader :orig_def, :game_dir, :game_module, :name, :config_file, :definition_method,
                :class_name, :maker_module_name, :my_class, :my_maker

    def initialize(orig_def, game_dir, game_module, skip_defaults: false, skip_validations: false)
      @orig_def             = orig_def
      @game_dir             = game_dir
      @game_module          = game_module
      @definition_method    = define_type
      self.send(@definition_method)
      set_defaults unless skip_defaults
      validate_component_definition unless skip_validations
    end

    def definition
      {
          name:              self.name,
          config_file:       self.config_file,
          class_name:        self.class_name,
          maker_module_name: self.class_name
      }
    end

    protected

    def set_defaults

    end

    def validate_component_definition
      check_config_file
      check_class_name
      check_maker_module
    end

    def define_type
      if orig_def.is_a? Hash
        return :from_hash
      elsif File.exists?(orig_def)
        return :from_file
      else
        return :from_name
      end
    end

    def from_hash
      @name              = orig_def[:name]
      @config_file       = orig_def[:config_file]
      @class_name        = orig_def[:class_name]
      @maker_module_name = orig_def[:maker_module_name]
    end

    def from_file
      @config_file       = orig_def
      @name              = name_from_file(config_file)
      @class_name        = name.upper_camelcase
      @maker_module_name = class_name + "Maker"
    end

    def from_name
      @name              = orig_def.snakecase
      @config_file       = "etc/#{name}.yml"
      @class_name        = name.upper_camelcase
      @maker_module_name = class_name + "Maker"
    end

    def check_config_file
      return if config_file.nil?
      return if File.exists?(config_file)
      raise GameParseError.new "No Config file found for Component[#{name}]: #{config_file}"
    end

    def check_class_name
    end

    def check_maker_module
    end
  end
end