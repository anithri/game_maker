module GameMaster
  module ConfigLoader
    module Stages
      module NormalizeGameModule

        class << self

          def load(config_obj)
            self.normalize_name(config_obj)
            self.normalize_module(config_obj)
            config_obj.boot.stage.normalize_game_module.success = true
            config_obj
          end

          def normalize_name(config_obj)
            if config_obj.loader.game_module_name?
              config_obj.boot.stage.normalize_game_module.name_source = :game_module_name
              config_obj.loader.game_module_name = self.determine_module(config_obj.loader.game_module_name)
            elsif config_obj.loader.game_module? && config_obj.loader.game_module
              config_obj.boot.stage.normalize_game_module.name_source = :game_module
              config_obj.loader.game_module_name = self.determine_module(config_obj.loader.game_module)
            elsif config_obj.loader.game_name? && config_obj.loader.game_name
              config_obj.boot.stage.normalize_game_module.name_source = :game_name
              config_obj.loader.game_module_name = config_obj.loader.game_name
              self.normalize_name(config_obj)
            else
              config_obj.boot.stage.normalize_game_module.name_source = :no_value
              config_obj.loader.game_module_name = false
            end
          end

          def normalize_module(config_obj)
            if config_obj.loader.game_module? && config_obj.loader.game_module
              config_obj.loader.game_module = self.parse_module(config_obj.loader.game_module)
            elsif config_obj.loader.game_module_name? && config_obj.loader.game_module_name
              config_obj.loader.game_module = self.parse_module(config_obj.loader.game_module_name)
            else
              config_obj.loader.game_module = false
            end
          end

          def determine_module(orig)
            return false unless orig
            return orig.to_s if orig.is_a? Module
            return false if orig.to_s.empty?
            return orig.titlecase.gsub(/ /,'')
          end

          def parse_module(orig)
            return false unless orig
            return orig if orig.is_a?(Module)
            return false if orig.empty?
            return Module.const_get(orig.titlecase.gsub(/ /,''))
          rescue NameError
            raise GameParseError.new("Couldn't convert #{orig.inspect} to a Module")
          end
        end
      end
    end
  end
end