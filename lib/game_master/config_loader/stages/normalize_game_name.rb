module GameMaster
  module ConfigLoader
    module Stages
      module NormalizeGameName
        class << self

          def load(config_obj)
            if config_obj.loader.game_name?
              config_obj.loader.game_name = determine_game_name(config_obj.loader.game_name)
            elsif config_obj.loader.game_dir? && config_obj.loader.game_dir
              config_obj.loader.game_name = determine_game_name(config_obj.loader.game_dir)
            else
              config_obj.loader.game_name = false
            end
            config_obj.boot.stage.normalize_game_name.success = true
            config_obj
          end

          def determine_game_name(name)
            return false unless name
            return false if name.to_s.empty?
            return name.basename.to_s.snakecase.titlecase if name.is_a?(Pathname)
            return name.to_s.snakecase.titlecase
          end
        end
      end
    end
  end
end