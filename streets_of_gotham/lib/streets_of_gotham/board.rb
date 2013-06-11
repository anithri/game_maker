module StreetsOfGotham
  class Board
    include ::GameMaster::Base
    define_attribute :description, type: String, default: ""
    define_collection :tiles, collection: true
  end
end


