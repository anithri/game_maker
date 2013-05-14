module StreetsOfGotham
  class MapLayout
    def initialize(options)
      @part_slots = options
    end

    def part_types
      @part_slots.keys
    end

    def position_for_part(part_type)
      return *@part_slots[part_type]
    end
  end
end