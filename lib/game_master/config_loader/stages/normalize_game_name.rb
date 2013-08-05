module GameMaster
  module ConfigLoader
    module Stages
      module NormalizeGameName
        class << self
          def load(config_obj)
            if config_obj.loader.game_name? && config_obj.loader.game_name?.to_s.length > 1
              config_obj.loader.game_name = config_obj.loader.game_name.to_s.snakecase.titlecase
            elsif config_obj.loader.game_dir?
              config_obj.loader.game_name = config_obj.loader.game_dir.basename.to_s.snakecase.titlecase
            else
              raise GameParseError, "No Game Name determined from initial config.  It is required, and defaults to the name of the game_dir"
            end
            config_obj.boot.stage.normalize_game_name.success = true
            return config_obj
          end
        end
      end
    end
  end
end