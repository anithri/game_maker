require 'streets_of_gotham/board'
module StreetsOfGotham
  class Tile
    include ::GameMaster::Base
    #parent StreetsOfGotham::Board
    define_attribute :name, required: true
    define_attribute :tile_type
  end
end
