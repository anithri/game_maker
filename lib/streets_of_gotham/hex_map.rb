require 'streets_of_gotham/map_position'
module StreetsOfGotham
  class HexMap
    attr_accessor :positions
    def self.load_content(filename = nil, position_obj = nil)
      filename ||= ::StreetsOfGotham.config.map_board_content
      position_obj ||= ::StreetsOfGotham::MapPosition
      self.new(::YAML.load_file(filename), position_obj)
    end

    def initialize(tile_locations, position_obj)
      @positions = []
      tile_locations.each do |loc|
        @positions << position_obj.new(loc)
      end
    end

    def positions_for_assignment
      @positions.inject({}){|hash, obj| hash[obj.coordinate] = obj; hash }
    end
  end
end