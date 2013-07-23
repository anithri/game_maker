module GameMaster
  module ConfigLoader
    module SecondStage

      def self.load(config)
        self.normalize_game_dir(config_obj)
        self.normalize_game_name(config_obj)
        self.normalize_game_module(config_obj)
        self.normalize_game_class(config_obj)
        self.normalize_game_maker_class(config_obj)

        config_obj.set_boot_stage(:second_stage)

      end

      def self.normalize_game_dir(config_obj)
        if config_obj.config.game_dir?
          config_obj.config.game_dir = self.determine_dir_name(config_obj.config.game_dir)
        else
          config_obj.config.game_dir = false
        end
      end

      def self.normalize_game_name(config_obj)

        

        config_obj.config.game_name = config_obj.config.game_name.titlecase
      end

      def self.normalize_game_module(config_obj)
      end

      def self.normalize_game_class(config_obj)
      end

      def self.normalize_game_maker_class(config_obj)
      end


      def self.determine_dir_name(orig_name)
        return false unless orig_name
        return orig_name if orig_name.is_a?(Pathname)
        return Pathname.new(orig_name).expand_path
        raise GameParseError.new("Couldn't convert #{orig_name.inspect} to a Pathname")
      end

    end
  end
end