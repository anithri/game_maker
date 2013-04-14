module StreetsOfGotham
  class TileDefinition
    attr_reader :name, :tile_type, :effects, :tags, :attachments

    def initialize(name, tile_type, effects, tags, attachments)
      @name, @tile_type, @effects, @tags, @attachments = name, tile_type, effects, tags, attachments
    end

    def is_tile_type?(type)
      tile_type == type
    end

  end
end