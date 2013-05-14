module StreetsOfGotham
  class ConfigLoader

    def initialize(klass, *parts_list)
      @klass = klass
      @parts_list = parts_list
    end

    def by_file(filename)
      a = ::YAML.load_file(filename)
      @klass.new(a)
    end

    def random
      by_file(path_for(@parts_list.sample))
    end

    def default
      by_file(path_for(@parts_list.first))
    end

    def path_for(file)
      "#{$game_config.data_dir}/#{file}"
    end

  end
end