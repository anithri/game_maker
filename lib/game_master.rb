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
  autoload :Master, 'game_master/master'

  # @param [Hash] opts options to be passed to ConfigLoader.
  # @option opts [String] :filename name of a file to boot config with
  # @option opts [String] :dirname  the name of the top directory of your game, load game_config.yml from that dir
  # @param [Hash] config hash to be passed to ConfigLoader, passed to GameMaster::Config.new as config
  # @param [Hash] game hash to be passed to ConfigLoader, passed to GameMaster::Config.new as game
  # The first key found in the list of [:filename, :dirname] is used to load the game_config.yml file and the rest are ignored.
  # @raise GameParseError if a problem happens during any stage of the Config Load Stage
  # @raise GameDefinitionError if a problem happens while creating a game from the Config
  # @return [Game]
  def self.game_from(opts, config = {}, game = {})
    Yell.new :stdout, name: "GameMaster"
    Yell::Repository.loggers.default = Yell["GameMaster"]

    game_config = GameMaster::ConfigLoader.load(opts, config, game)
    mk_game(game_config)
  end

  protected

  def self.mk_game(config)
    TestGame::Game.new(config)
    #config.runtime.game_maker_class.new(config)
  end

end

