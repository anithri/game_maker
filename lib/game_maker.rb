require "singleton"
require "yaml"
require 'ostruct'

require "game_maker/config_loader"
require "game_maker/version"

class GameParseError < StandardError
end

module GameMaker

  DEFAULT_CONFIG_FILE = File.dirname(__FILE__) + "/../etc/game_config.yml"

  def self.mk_game(game_config_file = DEFAULT_CONFIG_FILE)
    game_config = StreetsOfGotham::Config.load_file(game_config_file)
    game_maker = game_config.game_maker
    game_maker.mk_game(game_config)
    #StreetsOfGotham::GameMaker.mk_game(game_config)
  end

end

