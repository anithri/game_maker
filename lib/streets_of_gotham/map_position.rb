module StreetsOfGotham
  class MapPosition
    attr_reader :coordinate, :borders

    def initialize(options = {})
      @coordinate = options[:coordinate]
      @borders =    options[:borders]
      @special_travel = Hash.new{|h,k| h[k] = []}
      @special_travel[:surface] = borders
    end

    def travel_to?(destination, *modes )
      modes << :surface if modes.empty?
      modes.flatten.map{|mode| @special_travel[mode].include?(destination)}.include?(true)
    end

    def add_route(destination, mode)
      @special_travel[mode] << destination unless @special_travel[mode].include?(destination)
    end
  end
end