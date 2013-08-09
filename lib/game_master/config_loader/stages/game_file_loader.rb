require 'forwardable'
module GameMaster
  module ConfigLoader
    module Stages
      class GameFileLoader
        extend Forwardable
        FILE_GLOB = "**/*.{y,ya}ml"

        def self.load(config_obj)
          self.new(config_obj).load
          config_obj.boot.stage.game_load.success = true
          config_obj
        end
        def_delegators :@config, :loader, :boot

        def initialize(config_obj)
          @config = config_obj
        end

        def load
          scan_dirs.each do |dir|
            find_game_files(dir).each do |file|
              @config.merge_from_file(file, parent_keys(dir, file))
            end
          end

        end

        def find_game_files(parent_dir)
          files = Pathname.glob(parent_dir + FILE_GLOB)
          #sort by depth, shallowest files first
          return files.sort_by{|f| f.to_s.split(File::SEPARATOR).count }
        end

        def scan_dirs
          [@config.loader.game_dir]

        end

        # @param [Pathname] parent Parent direcotry of game files
        # @param [Pathname] game_file game file located (recursivly) in parent
        def parent_keys(parent_dir, game_file)
          return game_file.relative_path_from(parent_dir)
                          .dirname
                          .to_s
                          .split(File::SEPARATOR)
                          .reject{|e| e =="."}
                          .map(&:to_sym)
        end
      end
    end
  end
end

def load_dir_structure(dir)
  return unless dir
  dir.find.each do |child|
    next if child.directory?
    next if child == config.game_config_file
    next unless child.to_s =~ /\.ya?ml$/
    keys = child.relative_path_from(dir).each_filename.to_a.map(&:intern)[0..-2]
    insert_file(keys, child)
  end
end

def insert_file(keys, file)
  insert_into = keys.inject(game){|hash,key| hash = hash[key]}
  unless insert_into.respond_to?(:merge)
    raise GameParseError.new("Attempting to load #{file} into game with keys #{keys.inspect}.  But it already has a value of #{insert_into.inspect}")
  end
  contents = YAML.load_file(file)
  runtime.game_files[file.to_s] = contents
  insert_into.deep_merge! contents
end
