module StreetsOfGotham
  class MapLoader
    def self.by_file(filename)
      a = YAML.load_file(filename)
      StreetsOfGotham::Map.new(a[:board_name], a[:board_spaces])
    end

    def self.random
      return self.by_file($game_config.map_file) unless $game_config.map_file.respond_to?(:sample)
      self.by_file(path_for($game_config.map_file.sample))
    end

    def self.default
      return self.by_file(path_for($game_config.map_file)) unless $game_config.map_file.respond_to?(:first)
      self.by_file(path_for($game_config.map_file.first))
    end

    def self.path_for(file)
      "#{$game_config.data_dir}/#{file}"
    end
  end
end