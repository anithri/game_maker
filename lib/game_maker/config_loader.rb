require 'hashery'
require 'yaml'
require 'facets/string/camelcase'
require 'facets/string/titlecase'
module GameMaker
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
      config_opts = opts[:config_opts] || {}
      if opts.has_key? :filename
        return self.load_from_file(opts[:filename], config_opts)
      elsif opts.has_key? :dirname
        return self.load_from_dir(opts[:dirname], config_opts)
      elsif opts.has_key? :yaml_string
        return self.load_from_string(opts[:yaml_string], config_opts)
      elsif opts.has_key? :io
        return self.load_from_io(opts[:io], config_opts)
      else
        raise GameParseError.new(
                  "No :filename, :dirname, :yaml_string, or :io key found in: #{opts.inspect} "
              )
      end
    end

    # @return [Object]
    def self.load_from_file(filename, opts = {})
      raise GameParseError.new("No such file exists: #{filename}") unless File.exists?(filename)
      config = opts.merge(self.parse_yaml(File.open(filename)))
      config[:game_dir] ||= File.dirname(filename)
      config[:game_name] ||= File.basename(config[:game_dir]).titlecase
      config[:game_config_file] = filename
      config
    end

    def self.load_from_dir(dirname, opts = {})
      raise GameParseError.new("No dir found: #{dirname}") unless Dir.exists?(dirname)
      opts[:game_dir] ||= dirname
      self.load_from_file(dirname + "/game_config.yml", opts)
    end

    def self.load_from_string(yaml_string, opts = {})
      opts.merge(self.parse_yaml(yaml_string))
    end

    def self.load_from_io(readable_obj, opts = {})
      opts.merge(self.parse_yaml(readable_obj))
    end

    private

    def self.parse_yaml(readable_obj)
      ::YAML.load(readable_obj)
    end
  end
end