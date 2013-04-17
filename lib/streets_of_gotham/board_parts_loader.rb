module StreetsOfGotham
  module BoardPartsLoader
    def self.by_file(filename)
      a = YAML.load_file(filename)
      StreetsOfGotham::PartsCollection.new(a)
    end

    def self.random
      self.by_file(self.path_for(self.files_list.sample))
    end

    def self.default
      self.by_file(path_for(self.files_list.first))
    end

    def self.path_for(file)
      "#{$game_config.data_dir}/#{file}"
    end

    def self.files_list
      out = *$game_config.board_parts_file
    end

  end
end