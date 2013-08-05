module GameMaster
  module ConfigLoader
    module Stages
      module NormalizeGameMakerClass
        class << self
          def load(config_obj)
            l = config_obj.loader
            if l.game_maker_class?
              l.game_maker_class = normalize_class(l.game_module, l.game_maker_class)

            else
              maker_class = l.game_class.to_s.split("::").last + "Maker"
              begin
                l.game_maker_class = normalize_class(l.game_module,maker_class)
              rescue GameParseError
                l.game_maker_class = l.game_class
              end
            end

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