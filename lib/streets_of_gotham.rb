require "singleton"
require "yaml"
require 'ostruct'

require "streets_of_gotham/config_loader"
require "streets_of_gotham/version"

require "streets_of_gotham/map_position"
require "streets_of_gotham/map"

require "streets_of_gotham/board"
require "streets_of_gotham/board_maker"

require "streets_of_gotham/game"
require "streets_of_gotham/game_maker"
require "streets_of_gotham/map_layout"
require "streets_of_gotham/map_loader"
require "streets_of_gotham/config_loader"
require "streets_of_gotham/board_parts_loader"
require "streets_of_gotham/parts_collection"
require "streets_of_gotham/part"

class GameParseError < StandardError
end

module StreetsOfGotham

  DEFAULT_CONFIG_FILE = File.dirname(__FILE__) + "/../etc/game_config.yml"

  def self.mk_game(game_config_file = DEFAULT_CONFIG_FILE)
    game_config = StreetsOfGotham::Config.load_file(game_config_file)
    StreetsOfGotham::GameMaker.mk_game(game_config)
  end

end

