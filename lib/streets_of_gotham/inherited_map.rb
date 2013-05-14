module StreetsOfGotham
  class InheritedMap < BaseType
    attr_accessor :board_name, :spaces, :raw_data

    define_fields board_name: Object
    add_children ::StreetsOfGotham::MapPosition


  end
end