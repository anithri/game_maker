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

  # @param [Hash] opts options to be passed to Config.
  # @option opts [String] :filename name of a file to boot config with
  # @option opts [String] :dirname  the name of the top directory of your game, load game_config.yml from that dir
  # @option opts [Hash]   :config a hash containing config data to be used during load process. defaults to {}
  # @option opts [Hash]   :game_data a hash containing game data used to give initial values. defaults to {}
  # The first key found in the list of [:filename, :dirname] is used to load the game_config.yml file and the rest are ignored.
  # @raise GameParseError if a problem happens during any stage of the Config Load Stage
  # @raise GameDefinitionError if a problem happens while creating a game from the Config
  # @return [Game]
  def self.game_from(opts)
    Yell.new :stdout, name: "GameMaster"
    Yell::Repository.loggers.default = Yell["GameMaster"]

    config = GameMaster::ConfigLoader.load(opts)
    mk_game(config)
  end

  protected

  def self.mk_game(config)
    config.runtime.game_maker_class.new(config)
  end

end

