module StreetsOfGotham
  class TileCollection
    attr_reader :tiles
    TILE_DEF_OBJ = ::StreetsOfGotham::TileDefinition

    def initialize(*tile_definitions)
      @tiles_by_type = Hash.new{|h,k| h[k] = []}
      @tiles_by_name = {}
      @tiles = []
      tile_definitions.flatten.each do |tile_options|
        name        = tile_options[:name]
        type        = tile_options[:tile_type]
        tile_def = TILE_DEF_OBJ.new(name, type, tile_options)
        @tiles_by_name[name] = tile_def
        @tiles_by_type[type] << tile_def
        @tiles << tile_def
      end
    end

    def self.load_content(filename = ::StreetsOfGotham.config.map_elements_content)
      self.new(::YAML.load_file(filename))
    end

    def all_tile_types
      @tiles_by_type.keys
    end

    def parts_of_type(type)
      @tiles_by_type[type]
    end
  end
end








