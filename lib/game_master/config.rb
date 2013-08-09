require 'hash_deep_merge'
require 'hashery'

module GameMaster
  class Config
    attr_reader :game, :loader, :runtime

    CONTAINER = Hashery::OpenCascade


    def initialize(game,loader,runtime)
      raise ArgumentError unless [game,loader,runtime].all?{|e| e.is_a?(Hash)}
      @game    = mk_container(game)
      @loader  = mk_container(loader)
      @runtime = mk_container(runtime)
    end

    def boot
      runtime.boot
    end

    def merge_from_file(file, parent_keys = [])
      return if boot.game_files.include?(file)
      contents = YAML.load_file(file)
      if merge_at_root?(contents)

      else

      end
    end

    private
    def mk_container(initial_hash = {})
      CONTAINER[initial_hash]
    end

    def merge_at_root?(hash)
      ([:game,:loader,:runtime] & hash.keys).count > 0
    end

  end
end