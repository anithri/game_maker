module StreetsOfGotham
  class MapPosition
    attr_reader :coordinate, :borders, :raw_data

    def self.valid?(options)
      is_valid = true
      is_valid &&= options.is_a?(Hash)
      is_valid &&= options.has_key?(:coordinate)
      is_valid &&= ! options[:coordinate].nil?
      is_valid &&= options.has_key?(:borders)
      is_valid &&= options[:borders].is_a?(Array)
      is_valid
    end

    def initialize(options)
      @borders = options[:borders]
      @coordinate = options[:coordinate]
      @raw_data = options
    end
  end
end