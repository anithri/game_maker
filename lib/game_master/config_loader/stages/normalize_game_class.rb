module GameMaster
  module ConfigLoader
    module Stages
      class NormalizeGameClass
        
        def self.load(config_obj)
          ngc = self.new(config_obj)
          
          ngc.normalize_name
          ngc.normalize_class
          config_obj.boot.stage.normalize_game_class.success = true
          config_obj
        end
        
        def initialize(config)
          @config = config
        end

        def loader
          @config.loader
        end

        ["game_class_name", "game_class", "game_module"].each do |attr|
          self.class_eval <<-EOS
            def #{attr}; loader.#{attr}; end
            def #{attr}=(val); loader.#{attr} = val; end
            def #{attr}?; loader.#{attr}?; end
          EOS
        end

        def normalize_name
          if game_class? && game_class
            loader.game_class_name= determine_class(game_class)
          elsif game_class_name? && game_class_name
            loader.game_class_name= determine_class(game_class_name)
          elsif game_module? && game_module
            loader.game_class_name= "Game"
          else
            loader.game_class_name = false
          end
        end

        def normalize_class
          if game_class? && game_class
            loader.game_class = parse_class(game_class,game_module)
          elsif game_class_name? && game_class_name
            loader.game_class = parse_class(game_class_name,game_module)
          else
            loader.game_class = false
          end
        end

        def determine_class(orig)
          return false unless orig
          return orig.to_s.split("::").last if orig.is_a? Class
          return false if orig.to_s.empty?
          return orig.snakecase.titlecase.gsub(/ /,'')
        end

        def parse_class(orig, class_mod)
          return false unless orig
          return orig if orig.is_a?(Class)
          return false if orig.empty?
          return Module.const_get(orig.titlecase.gsub(/ /,'')) unless class_mod
          return class_mod.const_get(orig.titlecase.gsub(/ /,''))
        rescue NameError
          raise GameParseError.new("Couldn't convert #{orig.inspect} to a Module #{class_mod.inspect}")
        end

      end
    end
  end
end