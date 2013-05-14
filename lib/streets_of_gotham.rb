require "singleton"
require "yaml"
require 'ostruct'

require "streets_of_gotham/version"
require "streets_of_gotham/map_position"
require "streets_of_gotham/map"

require "streets_of_gotham/board"
require "streets_of_gotham/board_maker"
require "streets_of_gotham/base_type"
require "streets_of_gotham/inherited_map"

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
require "streets_of_gotham/base_type"

module StreetsOfGotham

  CONFIG_DIR = File.dirname(__FILE__) + "/../etc"
  DEFAULT_CONFIG = ::YAML.load_file("#{CONFIG_DIR}/game_config.yml")
  DEFAULT_CONFIG[:data_dir] ||= CONFIG_DIR
  $game_config = OpenStruct.new(DEFAULT_CONFIG.dup)

  def self.config
    $game_config
  end

  def self.reset_config
    self.config.marshal_load(DEFAULT_CONFIG.dup)
  end

  def self.load_config(options_hash = {})
    $game_config.marshal_load(options_hash)
  end

  def self.mk_game
    StreetsOfGotham::GameMaker.mk_game
  end

end

