require 'yell'
require 'attrio'
require 'pathname'

#require 'facets'
require 'facets/module/mattr'
require 'facets/string/snakecase'
require 'game_master/error'
require "game_master/version"
require "game_master/loggable"
require "game_master/utils"
require "game_master/base"
require "game_master/game"
require "game_master/define_component"

class GameParseError < StandardError
end

class GameDefinitionError < StandardError
end

module GameMaster
  autoload :Config, 'game_master/config'
  autoload :ConfigLoader, 'game_master/config_loader'

  DEFAULT_CONFIG_FILE = File.dirname(__FILE__) +
                        "/../streets_of_gotham/etc/game_config.yml"

  # @param [Hash] config options to be passed to Config.
  # @option config [String] :filename name of a file to boot config with
  # @option config [String] :dirname  the name of the top directory of your game, will try and load game_config.yml or <dirname>.yml
  # @option config [String] :yaml_string the string c/lib/game_master.rb:28ontaining the yaml for config
  # @option config [#read]  :io           an object to read yaml from
  # @option config [Hash]   :initial_opts a hash containing game definitions to be used as initial content, defaults to {}
  # The first key found in the list of [:filename, :dirname, :yaml_string, :io] is used to load the game_config.yml file and the rest are ignored.
  # @raise GameParseError if a problem happens during any stage of the Config Load Stage
  # @raise GameDefinitionError is a problem happens while creating a game from the Config
  # @return [Ganme]
  def self.game_from(config)
    Yell.new :stdout, name: "GameMaster"
    Yell::Repository.loggers.default = Yell["GameMaster"]

    config = GameMaster::Config.load(config)
    mk_game(config)
    #set_defaults(config)
    #check_validity(config)
    #mk_game(mk_config(config))
  end

  protected

  #TODO Find a way to genericize this to allow other config stores to be created
  def self.mk_config(raw_config)
    ::Hashery::OpenCascade[raw_config]
  end

  def self.set_defaults(config)
    config[:game_dir] ||= File.dirname(config[:game_config_file]) if config[:game_config_file]
    config[:game_name] ||= File.basename(config[:game_dir]).titlecase if config[:game_dir]
    config[:game_module_name] ||= self.to_s
    config[:game_class_name] ||= "Game"
    config[:game_part_files] ||= []
  end

  def self.check_validity(config)
    check_game_dir    config[:game_dir]
    check_game_module config[:game_module_name], config
    check_game_class  config[:_game_module], config[:game_class_name], config
  end

  def self.mk_game(config)
    config.runtime.game_maker_class.new(config)
  end

  def self.check_game_dir(dir)
    return dir if game_dir_ok?(dir)
    raise GameParseError.new("Could not determine :game_dir") unless dir
    raise GameParseError.new("No dir found: #{dir}")
  end

  def self.game_dir_ok?(dir)
    ! dir.nil? && File.directory?(dir)
  end

  def self.check_game_module(module_name, config)
    begin
      config[:_game_module] ||=  Module.const_get(module_name)
    rescue NameError
      raise GameParseError.new("Module could not be found: #{module_name}")
    end
  end

  def self.check_game_class(module_name, class_name, config)
    begin
      config[:_game_class] ||= module_name.const_get(class_name)
    rescue
      raise GameParseError.new("Class could not be found: #{module_name}::#{class_name}")
    end
  end
end

