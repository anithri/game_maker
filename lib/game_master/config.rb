require 'hash_deep_merge'
require 'hashery'

module GameMaster
  class Config
    attr_reader :boot, :config, :game, :runtime

    CONTAINER = Hashery::OpenCascade

    def initialize(boot = {},config = {},game = {},runtime = {})
      raise ArgumentError unless [boot,config,game,runtime].all?{|e| e.is_a?(Hash)}
      boot[:original_config] = config.dup

      @boot    = mk_container(boot)
      @config  = mk_container(config)
      @game    = mk_container(game)
      @runtime = mk_container(runtime)

    end

    def mk_container(initial_hash = {})
      CONTAINER[initial_hash]
    end

    def set_boot_stage(stage_name)
      boot.send(stage_name).config  = config.dup
      boot.send(stage_name).game    = game.dup
      boot.send(stage_name).runtime = runtime.dup
    end

  end
end