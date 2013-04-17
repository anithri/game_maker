module StreetsOfGotham
  class MapPosition
    attr_reader :coordinate, :borders
    def initialize(coordinate, *borders)
      @borders = borders.flatten
      @coordinate = coordinate
    end
  end
end