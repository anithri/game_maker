module GameMaker
  class Game
    attr_reader :config, :components

    def initialize(config)
      @config = config
      @components = []
      load_components(config.components?)
    end

    def load_components(component_list)

    end

    def components_list
      return config.components? if config.componets? && config.components.is_a?(Array)
      component_glob = config.game_dir + "/etc/*.yml"
      components = Dir.glob(componet_glob)
    end
  end
end