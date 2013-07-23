
module GameMaster
  module ConfigLoader
    module FirstStage

      def self.load(opts, config_obj)
        if opts.has_key? :filename
          self.load_from_file(opts[:filename],config_obj)
        elsif opts.has_key? :dirname
          self.load_from_dir(opts[:dirname],config_obj)
        #elsif opts.has_key? :yaml_string
        #  self.load_from_string(opts[:yaml_string],config_obj)
        #elsif opts.has_key? :io
        #  self.load_from_io(opts[:io],config_obj)
        else
          raise GameParseError.new("No :filename, :dirname, :yaml_string, or :io key found in: #{opts.inspect} ")
        end
        config_obj.set_boot_stage(:first_stage)
      end

      protected
      # @return [Object]
      def self.load_from_file(filename, config_obj)
        file = filename.is_a?(Pathname) ? filename : Pathname.new(filename).expand_path
        raise GameParseError.new("file not found: #{filename}") unless file.file?
        contents = self.parse_yaml(file.open)

        config_obj.boot.boot_method        = :file
        config_obj.boot.boot_data          = filename
        config_obj.config.game_dir         = file.dirname
        config_obj.config.game_config_file = file
        self.merge_contents(contents, config_obj)
      end

      def self.load_from_dir(dirname, config_obj)
        dir = dirname.is_a?(Pathname) ? dirname : Pathname.new(dirname).expand_path
        raise GameParseError.new("dir not found: #{dirname}") unless dir.directory?
        self.load_from_file(dir + self.config_file_name(config_obj), config_obj)
        config_obj.boot.boot_method = :dir
        config_obj.boot.boot_data        = dirname
      end

      #def self.load_from_string(yaml_string, config_obj)
      #  #TODO convert
      #  config = self.parse_yaml(yaml_string)
      #  config[:boot_method] = :string
      #  config[:boot_data] = yaml_string
      #  config[:game_dir] = false
      #  config
      #end
      #
      #def self.load_from_io(readable_obj, config_obj)
      #  #TODO catch bad IO and reraise as parse error
      #  config = self.parse_yaml(readable_obj)
      #  config[:boot_method] = :io
      #  config[:boot_data] = readable_obj
      #  config[:game_dir] = false
      #  config
      #end

      def self.parse_yaml(readable_obj)
        ::YAML.load(readable_obj)
      end
      
      def self.config_file_name(config_obj)
        if config_obj.config.game_config_file? && config_obj.config.game_config_file
          config_obj.config.game_config_file
        else
          "game_config.yml"
        end
      end
      
      def self.merge_contents(contents, config_obj)
        config_obj.config. deep_merge(contents)
        config_obj.boot.   deep_merge(contents[:boot   ]) if contents.has_key?(:boot  )
        config_obj.game.   deep_merge(contents[:game   ]) if contents.has_key?(:game   )
        config_obj.runtime.deep_merge(contents[:runtime]) if contents.has_key?(:runtime)
      end
    end
  end
end