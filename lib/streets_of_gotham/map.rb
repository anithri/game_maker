module StreetsOfGotham
  class Map
    attr_accessor :board_name, :spaces

    def initialize(board_name, spaces)
      @board_name = board_name
      @spaces = []
      spaces.each do |space|
        @spaces << ::StreetsOfGotham::MapPosition.new(space[:coordinate],space[:borders])
      end
    end

    def as_map
      spaces.inject({}){|hash,space| hash[space.coordinate] = space; hash }
    end
  end
end