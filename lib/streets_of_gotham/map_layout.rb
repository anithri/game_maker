module StreetsOfGotham
  class MapLayout
    attr_accessor :parts_by_type
    TILE_OBJ = ::StreetsOfGotham::Tile

    def self.load_content(options = {})
      filename = options.fetch(:filename, ::StreetsOfGotham::CONFIG.map_layout_content)

      #TODO Add in some checks or error handling for making sure the given map and map_style fit together
      # For now assuming they'll work together and fix errors in the data files.
      self.new(::YAML.load_file(filename))
    end

    def initialize(collection = {})
      @parts_by_type = {}
      collection.keys.each do |segment|
        @parts_by_type[segment] = collection[segment].sample
      end
    end

    def generate(map_parts, positions)
      all = []
      @parts_by_type.each do |key, *list|
        warn "=" * 40
        warn key.inspect
        warn "-" * 40
        warn list.inspect
        warn "-" * 40
        warn map_parts.parts_of_type(key).inspect
        warn "=" * 40
        #map_parts.parts_of_type(key).shuffle.each do |spots|
        #  all << TILE_OBJECT.mk_tile(positions, spots, options)
        #end
      end
      #TODO Make this into a GameMap object
      all
    end
  end
end