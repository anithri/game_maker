require 'hash_deep_merge'
require 'hashery'
require 'yaml'
require 'facets/string/camelcase'
require 'facets/string/titlecase'

module GameMaster
  module ConfigLoader

    RESERVED_KEYS = [:game_dir, :game_name, :game_config_file, :game_module_name,
                     :game_maker_class_name, :game_class_name]

    # @param [Hash] opts options to be passed to ConfigLoader  Config loader will use the first of
      # the four opts listed that it finds and ignore the other 3, finally passing config_opts whit
      # whatever options was used.
    # @option opts [String]  :filename    the name of a game config file
    # @option opts [dirname] :dirname     the name of the top directory of your game
    # @option opts [String]  :yaml_string the string containing the yaml for config
    # @option opts [#read]   :io           an object to read yaml from
    # @option opts [Hash]    :config_opts a hash to be merged with the game config file options
    def self.load(opts)
      if opts.has_key? :filename
        return self.load_from_file(opts[:filename])
      elsif opts.has_key? :dirname
        return self.load_from_dir(opts[:dirname])
      elsif opts.has_key? :yaml_string
        return self.load_from_string(opts[:yaml_string])
      elsif opts.has_key? :io
        return self.load_from_io(opts[:io])
      else
        raise GameParseError.new("No :filename, :dirname, :yaml_string, or :io key found in: #{opts.inspect} ")
      end
    end

    # @return [Object]
    def self.load_from_file(filename)
      file = filename.is_a?(Pathname) ? filename : Pathname.new(filename).expand_path
      raise GameParseError.new("No such file exists: #{filename}") unless file.file?
      contents = self.parse_yaml(file.open)
      contents[:boot_method] = :file
      contents[:boot_data] = filename
      contents[:game_dir] ||= file.dirname
      contents[:game_config_file] = file
      contents
    end

    def self.load_from_dir(dirname)
      dir = dirname.is_a?(Pathname) ? dirname : Pathname.new(dirname).expand_path
      raise GameParseError.new("No dir found: #{dirname}") unless dir.directory?
      config = self.load_from_file(dir + "game_config.yml")
      config[:boot_method] = :dir
      config[:boot_data] = dirname
      config
    end

    def self.load_from_string(yaml_string)
      #TODO catch malformed string errors and reraise as parse error
      config = self.parse_yaml(yaml_string)
      config[:boot_method] = :string
      config[:boot_data] = yaml_string
      config[:game_dir] = false
      config
    end

    def self.load_from_io(readable_obj)
      #TODO catch bad IO and reraise as parse error
      config = self.parse_yaml(readable_obj)
      config[:boot_method] = :io
      config[:boot_data] = readable_obj
      config[:game_dir] = false
      config
    end

    private

    def self.parse_yaml(readable_obj)
      ::YAML.load(readable_obj)
    end
  end
end