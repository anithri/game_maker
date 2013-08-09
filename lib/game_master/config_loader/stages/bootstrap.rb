
module GameMaster
  module ConfigLoader
    module Stages
      module Bootstrap
        class << self
          def load(config_obj)
            if config_obj.loader.filename?
              self.load_from_file(config_obj.loader.filename,config_obj)
            elsif config_obj.loader.dirname?
              self.load_from_dir(config_obj.loader.dirname,config_obj)
            #elsif opts.has_key? :yaml_string
            #  self.load_from_string(opts[:yaml_string],config_obj)
            #elsif opts.has_key? :io
            #  self.load_from_io(opts[:io],config_obj)
            else
              raise GameParseError.new("No :filename or :dirname key found ")
            end
            config_obj.boot.stage.first_stage.success = true
            config_obj
          end


          protected
          # @return [Object]
          def load_from_file(filename, config_obj)
            file = filename.is_a?(Pathname) ? filename : Pathname.new(filename).expand_path
            raise GameParseError.new("file not found: #{filename}") unless file.file?
            contents = self.parse_yaml(file.open)

            config_obj.boot.stage.first_stage.arg_type = :filename
            config_obj.boot.stage.first_stage.data = filename
            config_obj.loader.game_dir         = file.dirname
            config_obj.loader.game_config_file = file
            config_obj.boot.game_files = [file]

            self.merge_contents(contents, config_obj)
          end

          def load_from_dir(dirname, config_obj)
            dir = dirname.is_a?(Pathname) ? dirname : Pathname.new(dirname).expand_path
            raise GameParseError.new("dir not found: #{dirname}") unless dir.directory?

            self.load_from_file(dir + self.config_file_name(config_obj), config_obj)

            config_obj.boot.stage.first_stage.arg_type = :dirname
            config_obj.boot.stage.first_stage.data = dir
          end

          #def load_from_string(yaml_string, config_obj)
          #  #TODO convert
          #  config = self.parse_yaml(yaml_string)
          #  config[:boot_method] = :string
          #  config[:boot_data] = yaml_string
          #  config[:game_dir] = false
          #  config
          #end
          #
          #def load_from_io(readable_obj, config_obj)
          #  #TODO catch bad IO and reraise as parse error
          #  config = self.parse_yaml(readable_obj)
          #  config[:boot_method] = :io
          #  config[:boot_data] = readable_obj
          #  config[:game_dir] = false
          #  config
          #end

          def parse_yaml(readable_obj)
            ::YAML.load(readable_obj)
          end

          def config_file_name(config_obj)
            if config_obj.loader.game_config_file? && config_obj.loader.game_config_file
              config_obj.loader.game_config_file
            else
              "game_config.yml"
            end
          end

          def merge_contents(contents, config_obj)
            config_obj.game.   deep_merge(contents[:game   ]) if contents.has_key?(:game   )
            config_obj.loader. deep_merge(contents[:loader])  if contents.has_key?(:loader )
            config_obj.runtime.deep_merge(contents[:runtime]) if contents.has_key?(:runtime)
          end
        end
      end
    end
  end
end