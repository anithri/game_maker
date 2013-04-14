module StreetsOfGotham
  class NoTile
    include ::Singleton

    def name
      "Gotham Bay?" #TODO consider other names
    end

    def effect
      ::StreetsOfGotham::NoEffect.instance
    end

    def location
      ::StreetsOfGotham::NoLocation.instance
    end

    def hex_size
      0
    end
  end
end