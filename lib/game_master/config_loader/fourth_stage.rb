
module GameMaster
  module ConfigLoader
    module FourthStage

      def self.load(opts, config)
        if opts.has_key? :filename
          return self.load_from_file(opts[:filename])
        elsif opts.has_key? :dirname
          return self.load_from_dir(opts[:dirname])
        elsif opts.has_key? :yaml_string
          return self.load_from_string(opts[:yaml_string])
        elsif opts.has_key? :io
          return self.load_from_io(opts[:io])
        else
          raise GameParseError.new("No :filename, :dirname, :yaml_string, or :io key found in: #{opts.inspect} ")
        end
      end

      protected
      # @return [Object]
      def self.load_from_file(filename)
        file = filename.is_a?(Pathname) ? filename : Pathname.new(filename).expand_path
        raise GameParseError.new("No such file exists: #{filename}") unless file.file?
        contents = self.parse_yaml(file.open)
        contents[:boot_method] = :file
        contents[:boot_data] = filename
        contents[:game_dir] ||= file.dirname
        contents[:game_config_file] = file
        contents
      end

      def self.load_from_dir(dirname)
        dir = dirname.is_a?(Pathname) ? dirname : Pathname.new(dirname).expand_path
        raise GameParseError.new("No dir found: #{dirname}") unless dir.directory?
        config = self.load_from_file(dir + "game_config.yml")
        config[:boot_method] = :dir
        config[:boot_data] = dirname
        config
      end

      def self.load_from_string(yaml_string)
        #TODO catch malformed string errors and reraise as parse error
        config = self.parse_yaml(yaml_string)
        config[:boot_method] = :string
        config[:boot_data] = yaml_string
        config[:game_dir] = false
        config
      end

      def self.load_from_io(readable_obj)
        #TODO catch bad IO and reraise as parse error
        config = self.parse_yaml(readable_obj)
        config[:boot_method] = :io
        config[:boot_data] = readable_obj
        config[:game_dir] = false
        config
      end

    end

    def self.parse_yaml(readable_obj)
      ::YAML.load(readable_obj)
    end

  end
end