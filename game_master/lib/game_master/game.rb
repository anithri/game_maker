module GameMaster
  class Game
    attr_reader :config

    def initialize(config)
      @config = config
    end

  end
end