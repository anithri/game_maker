module GameMaster
  module ComponentLoader
    class << self
      def load_component(component_def, game_dir, game_module,)
        config = nil
        if component_def.is_a? Hash
          config = component_def
        elsif File.exists?(component_def)
          config = make_definition_from_file_name(component_def, game_dir, game_module)
        elsif File.exists?(game_dir + "/" + component_def)
          config = make_definition_from_file_name(game_dir + "/" +component_def, game_dir, game_module)
        else
          config = make_definition_from_name(component_def, game_dir, game_module)
        end
        return load_definition
      end

      def load_definitions_from_file(definition, game_dir, game_module)

      end

      def make_definition(raw_name, game_dir)
        if raw_name.include?(".") || raw_name.include?("/")
          return make_definition_from_file_name(raw_name)
        else
          return make_definition_from_name(raw_name, game_dir)
        end
      end

      def make_definitions_from_file_name(file_name)
        out = {}
        out[:config_file] = file_name
        out[:name] = File.basename(a,File.extname(a))
      end
    end
  end
end
