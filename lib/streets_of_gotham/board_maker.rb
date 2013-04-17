module StreetsOfGotham
  module BoardMaker
    def self.mk_board
      map = StreetsOfGotham::MapLoader.default
      layout = StreetsOfGotham::ConfigLoader.default
      parts = StreetsOfGotham::BoardPartsLoader.default
      StreetsOfGotham::Board.new()
    end
  end
end