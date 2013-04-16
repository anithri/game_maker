module StreetsOfGotham
  module MapMaker
    def self.mk_map
      @map_board = ::StreetsOfGotham.config.map_board.load_content       #::StreetsOfGotham::HexMap
      @map_elements = ::StreetsOfGotham.config.map_elements.load_content #::StreetsOfGotham::TileCollection
      @map_layout = ::StreetsOfGotham.config.map_layout.load_content     #::StreetsOfGotham::MapStyle

      warn @map_board.inspect
      warn @map_elements.inspect
      warn @map_layout.inspect

      #@map_layout.generate(@map_elements, @map_board.positions_for_assignment)
    end
  end
end



