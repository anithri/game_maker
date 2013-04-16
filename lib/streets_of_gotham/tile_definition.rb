module StreetsOfGotham
  class TileDefinition
    attr_reader :name, :tile_type, :effects, :tags, :attachments

    def initialize(name, tile_type, options = {})
      #@name, @tile_type, @effects, @tags, @attachments = name, tile_type, effects, tags, attachments
      @name, @tile_type = name, tile_type
      @effects = options.fetch(:effects, [])
      @tags = options.fetch(:tags, [])
      @attachments = options.fetch(:attachments, [])
    end

    def is_tile_type?(type)
      tile_type == type
    end

  end
end