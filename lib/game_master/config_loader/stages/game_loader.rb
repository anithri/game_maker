require 'forwardable'
module GameMaster
  module ConfigLoader
    module Stages
      class GameLoader
        extend Forwardable

        def self.load(config_obj)
          self.new(config_obj).load
          config_obj.boot.stage.game_load.success = true
          config_obj
        end
        def_delegators :@config, :loader, :boot

        def initialize(config_obj)
          @config = config_obj
          set_loader_values
        end

        def set_loader_values
          boot.stage.game_loader.scan_dirs  = mk_array(loader.scan_dirs?).map{|e| Pathname.new(e)}
          boot.stage.game_loader.scan_dirs.unshift(loader.game_dir?) if loader.game_dir?
          boot.stage.game_loader.game_files = mk_array(loader.game_files?).map{|e| Pathname.new(e)}
        end

        def load
          boot.stage.game_loader.scan_dirs.each do |dir|
            next unless dir.directory?
            load_from_dir(dir)
          end
        end

        def load_from_dir(dir)

        end


        def mk_array(val)
          return [] if val.nil?
          return val if val.is_a?(Array)
          return [val]
        end

      end
    end
  end
end
