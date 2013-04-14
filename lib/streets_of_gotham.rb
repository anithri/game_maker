require "singleton"
require "yaml"
require 'ostruct'

require "streets_of_gotham/version"

require "streets_of_gotham/no_tile"
require "streets_of_gotham/tile"
require "streets_of_gotham/tile_definition"
require "streets_of_gotham/tile_collection"


require "streets_of_gotham/map_position"
require "streets_of_gotham/hex_map"

require "streets_of_gotham/no_location"
require "streets_of_gotham/location"

require "streets_of_gotham/map_layout"

module StreetsOfGotham
  CONFIG_DIR = File.dirname(__FILE__) + "/../etc"
  CONFIG = OpenStruct.new(data_dir: CONFIG_DIR,

                          map_board: ::StreetsOfGotham::HexMap,
                          map_board_content: "#{CONFIG_DIR}/hex_map.yml",

                          map_elements: ::StreetsOfGotham::TileCollection,
                          map_elements_content: "#{CONFIG_DIR}/board_parts.yml",

                          map_layout: ::StreetsOfGotham::MapLayout,
                          map_layout_content: "#{CONFIG_DIR}/map_layout.yml",
  )
  def self.config
    CONFIG
  end
end

require "streets_of_gotham/game_map"
require "streets_of_gotham/no_effect"

require "streets_of_gotham/map_maker"
