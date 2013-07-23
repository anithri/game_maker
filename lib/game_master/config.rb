require 'hash_deep_merge'
require 'hashery'

module GameMaster
  class Config
    attr_reader :boot, :config, :game_data, :runtime

    def initialize(boot = {},config = {},game_data = {},runtime = {}, container = Hashery::OpenCascade)
      raise ArgumentError unless [boot,config,game,runtime].all?{|e| e.is_a?(Hash)}
      @container = container
      @game_data = self.mk_config(game_data)
      @boot      = self.mk_config(boot)
      @config    = self.mk_config(config)
      @runtime   = self.mk_config(runtime)

      boot.original_config = config
    end

    def mk_container(initial_hash = {})
      @container.new.deep_merge(initial_hash)
    end

  end
end