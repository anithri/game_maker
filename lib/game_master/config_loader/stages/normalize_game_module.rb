module GameMaster
  module ConfigLoader
    module Stages
      module NormalizeGameModule

        class << self

          def load(config_obj)
            l = config_obj.loader
            l.game_module = normalize_name(l.game_module? || l.game_name?)

            config_obj.boot.stage.normalize_game_module.success = true
            config_obj
          end

          def normalize_name(orig)
            return orig if orig.is_a?(Module)
            return Module.const_get(orig.to_s.snakecase.titlecase.camelize)
          rescue NameError
            raise GameParseError.new("can't convert #{orig.inspect} to module")
          end

        end
      end
    end
  end
end