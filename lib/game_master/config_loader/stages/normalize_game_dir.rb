module GameMaster
  module ConfigLoader
    module Stages
      module NormalizeGameDir
        class << self
          def load(config_obj)
            if config_obj.loader.game_dir?
              config_obj.loader.game_dir = determine_dir_name(config_obj.config.game_dir)
            else
              config_obj.loader.game_dir = false
            end
            config_obj.boot.stage.normalize_game_dir.success = true
            config_obj
          end

          def determine_dir_name(orig_name)
            return false unless orig_name
            return orig_name if orig_name.is_a?(Pathname)
            return false if orig_name.empty?
            return Pathname.new(orig_name).expand_path
            raise GameParseError.new("Couldn't convert #{orig_name.inspect} to a Pathname")
          end

        end
      end
    end
  end
end
