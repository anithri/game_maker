require "singleton"
require "yaml"
require 'ostruct'

require "game_maker/config_loader"
require "game_maker/version"

require "game_maker/map_position"
require "game_maker/map"

require "game_maker/board"
require "game_maker/board_maker"

require "streets_of_gotham/game"
require "streets_of_gotham/game_maker"
require "game_maker/map_layout"
require "game_maker/map_loader"
require "game_maker/config_loader"
require "game_maker/board_parts_loader"
require "game_maker/parts_collection"
require "game_maker/part"

class GameParseError < StandardError
end

module StreetsOfGotham

  DEFAULT_CONFIG_FILE = File.dirname(__FILE__) + "/../etc/game_config.yml"

  def self.mk_game(game_config_file = DEFAULT_CONFIG_FILE)
    game_config = StreetsOfGotham::Config.load_file(game_config_file)
    game_maker = game_config.game_maker
    game_maker.mk_game(game_config)
    #StreetsOfGotham::GameMaker.mk_game(game_config)
  end

end

