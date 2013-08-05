module GameMaster
  module ConfigLoader
    module Stages
      module NormalizeGameClass
        class << self
          def load(config_obj)
            l = config_obj.loader
            l.game_class = normalize_class(l.game_module, l.game_class? || "Game")

            config_obj.boot.stage.normalize_game_class.success = true
            config_obj
          end

          def normalize_class(game_module, game_class)
            return game_class if game_class.is_a?(Class)
            return game_module.const_get(game_class.to_s.snakecase.titlecase.camelize)
          rescue NameError
            raise GameParseError.new("Couldn't find class #{game_class.snakecase.titlecase.camelize} in Module #{game_module}")
          end
        end
      end
    end
  end
end