require 'streets_of_gotham/game'
require 'streets_of_gotham/tile'
module StreetsOfGotham
  class Board
    include ::GameMaster::Base
    parent StreetsOfGotham::Game
    define_attribute :description, type: String, default: ""
    define_collection :tiles, type: StreetsOfGotham::Tile, unique: :name

  end
end


