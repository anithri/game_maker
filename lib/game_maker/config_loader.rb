require 'hashery'
require 'yaml'

module GameMaker
  module ConfigLoader

    RESERVED_KEYS = [:root_dir, :game_name]

    # @raise [GameParseError] when passed a string that is neither an
    #   existing filename or a yaml string
    # @overload load(io_obj, opts = {})
    #   @param [#read] file IO object than can be #read
    #   @param [Hash] opts Additional settings to add to config
    # @overload load(file_name, opts = {})
    #   @param [String] file filename
    #   @param [Hash] opts Additional settings to add to config
    # @overload load(dir_name, opts = {})
    #   @param [String] file directory that contains "etc/game_config.yml"
    #   @param [Hash] opts Additional settings to add to config
    # @overload load(yaml_string, opts = {})
    #   @param [String] file string containing yaml
    #   @param [Hash] opts Additional settings to add to config
    # @option opts [String] :game_name core name of the game.
    # @option opts [String] :root_dir root dir containing game definition
    # @return [::Hashery::OpenCascade]
    def self.load(file, opts = {})
      config = nil
      if file.respond_to?(:read)
        config = self.parse_yaml(file)
      elsif File.exists?(file)
        config = self.parse_yaml(File.open(file,"r"))
        root_dir = File.dirname(file) + "/../"
        config[:root_dir] = root_dir unless config.has_key?(:root_dir)
      elsif Dir.exists?(file)
        config = self.parse_yaml(File.open(file + "/etc/game_config.yml"))
        config[:root_dir] = file.end_with?("/") ? file : file + "/"
      elsif file.respond_to?(:start_with?) && file.start_with?("---")
        config = self.parse_yaml(file)
      else
        raise GameParseError.new("Unable to find file or bad" +
                                 "yaml formatting: #{file}")
      end
      config = opts.merge(config)
      process(config, file)
    end

    private

    def self.bootstrap_settings(config, possible_root_dir)
      config.game_name = get_game_name(config) unless config.game_name?
    end

    def self.parse_yaml(readable_obj)
      ::YAML.load(readable_obj)
    end

    def self.process(raw_config, raw)
      set_root_dir(raw_config)
      set_game_name(raw_config)
      #TODO code for fetching or constructing core_game_class
      config = ::Hashery::OpenCascade[raw_config]
    end

    def self.set_root_dir(raw_config, raw)
      unless raw_config.has_key?(:root_dir) && File.directory?(raw_config[:root_dir])
        raise GameParseError.new("Could not determine :root_dir")
      end
    end

    def self.set_game_name(config)
      return config[:game_name] if config.has_key?(:game_name)
      if config.has_key?("root_dir")
        config[:game_name] = File.split(config[:root_dir]).last
        return config[:game_name]
      end
      if (config.keys - RESERVED_KEYS).count == 1
        config[:game_name] = (config.keys - RESERVED_KEYS).first
        return config[:game_name]
      end
      raise GameParseError.new("Could not determine :game_name")
    end

    def get_game_class(config)
      game_name = config.game_name
      class_name = config.main_class? ? config.main_class : "Game"
      maker_name = config.main_class? ? config.main_class : "GameMaker"
    end

    def self.get_game_name(config)
      return config.keys.first if config.keys.count == 1
    end
  end
end