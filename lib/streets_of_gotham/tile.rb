  module StreetsOfGotham
  class Tile
    attr_accessor :name, :tile_type, :locations, :effects, :tags, :position, :attachments

    def initialize(position, options = {})
      @position = position

      @name        = options[:name]
      @tile_type   = options[:tile_type]
      @effects     = options.fetch(:effects, [])
      @locations   = options.fetch(:locations, [])
      @tags        = options.fetch(:tags, [])
      @attachments = options.fetch(:attachments, [])

      @locations.each do |loc|
        @position.add_route(loc, :landmark)
      end

    end

    def self.mk_tile(positions, spots, options = {})
      each_tile = spots.respond_to?(:each) ? spots : [spots]
      out = []
      spots.each do |p|
        out << self.new(position.delete(p), options)
      end
      out
    end
  end
end