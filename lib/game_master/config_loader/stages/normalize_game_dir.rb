module GameMaster
  module ConfigLoader
    module Stages
      module NormalizeGameDir
        class << self
          def load(config_obj)
            if config_obj.loader.game_dir?
              config_obj.loader.game_dir = determine_dir_name(config_obj.loader.game_dir)
            else
              config_obj.loader.game_dir = false
            end
            validate_dir_name(config_obj)
            config_obj.boot.stage.normalize_game_dir.success = true
            config_obj
          end

          def determine_dir_name(orig_name)
            return false unless orig_name
            return orig_name.expand_path if orig_name.is_a?(Pathname)
            return false if orig_name.empty?
            return Pathname.new(orig_name).expand_path
            raise GameParseError.new("Couldn't convert #{orig_name.inspect} to a Pathname")
          end

          def validate_dir_name(config_obj)
            return unless config_obj.loader.game_dir
            unless config_obj.loader.game_dir.directory?
              raise GameParseError.new("Game Dir: #{config_obj.loader.game_dir} does not exist.")
            end
          end
        end
      end
    end
  end
end
