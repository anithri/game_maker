module StreetsOfGotham
  class Location
    attr_reader :name, :effect
    def initialize(name, effect: StreetsOfGotham::NoEffect.instance)
      @name = name
      @effect = effect
    end
  end
end