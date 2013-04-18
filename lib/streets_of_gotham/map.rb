module StreetsOfGotham
  class Map
    attr_accessor :board_name, :spaces, :raw_data

    @@position_obj = ::StreetsOfGotham::MapPosition

    def mk_position(options)
      @@position_obj.new(options)
    end

    def self.valid?(options)
      is_valid = true
      is_valid &&= options.is_a?(Hash)
      is_valid &&= options.has_key?(:board_name)
      is_valid &&= options.has_key?(:board_name)
      is_valid &&= options[:board_name].is_a?(Array)

    end

    def initialize(options)
      @board_name = options[:board_name] = board_name
      @spaces = {}
      positions.each do |raw|
        position = mk_position(raw)
        @spaces[position.coordinate] = position
      end
    end

    def at_coordinate(val)
      @spaces[val]
    end
  end
end