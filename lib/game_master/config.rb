require 'hash_deep_merge'
require 'hashery'
require 'yaml'
require 'facets/string/camelcase'

module GameMaster
  class Config

    attr_accessor :boot, :game, :runtime, :config

    def initialize(boot = {},config = {},game = {},runtime = {})
      raise ArgumentError unless [boot,config,game,runtime].all?{|e| e.is_a?(Hash)}
      @game    = self.mk_config(game)
      @boot    = self.mk_config(boot)
      @boot.original_config = config
      @config  = self.mk_config(config)
      @runtime = self.mk_config(runtime)
    end

    # @param opts [Hash]
    #
    #
    def self.load(opts)
      config = self.new(opts.fetch(:boot,{}),
                        opts,
                        opts.fetch(:game,{}),
                        {}
      )
      config.boot.initial_config = config.config
      config.load_first_stage
      config.load_second_stage
      config.load_third_stage
      config.load_fourth_stage

      config
    end

    def load_first_stage
      first_stage = GameMaster::ConfigLoader.load(config)
      self.config.merge!(first_stage)
      self.game.merge!(first_stage.fetch(:game,{}))
      self.boot.first_stage = first_stage
      self.boot.boot_method = first_stage[:boot_method]
      self.boot.boot_data = first_stage[:boot_data]

      self
    end

    def load_second_stage
      if config.game_dir?
        config.game_dir = normalize_game_dir(config.game_dir)
      else
        config.game_dir = false
      end
      config.game_name        = config.game_dir.basename.to_s if config.game_dir? && ! config.game_name?
      config.game_name        = config.game_name.upper_camelcase if config.game_name?
      config.game_module      = config.game_name if config.game_name? && ! config.game_module?
      config.game_module      = config.game_module.to_s.upper_camelcase
      config.game_class       = "Game" unless config.game_class?
      config.game_module      = config.game_module.to_s.upper_camelcase
      config.game_maker_class = false unless config.game_maker_class?
      config.game_maker_class = config.game_maker_class.to_s.upper_camelcase if config.game_maker_class
      boot.second_stage = config.dup
      self
    end

    def load_third_stage
      check_game_dir?
      check_game_module?
      check_game_class?
      check_game_maker_class?
      boot.third_stage = config.dup
    end

    def load_fourth_stage
      return self unless config.game_dir
      load_dir_structure(config.game_dir)

      self
    end

    protected

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

    def normalize_game_dir(value)
      return false unless value
      return value if value.is_a?(Pathname)
      return Pathname.new(value).expand_path if value.respond_to?(:to_s)
      raise GameParseError.new("Can't determine game_dir from #{config.game_dir.inspect}")
    end

    def self.mk_config(opts)
      ::Hashery::OpenCascade[opts]
    end
    def mk_config(opts)
      self.class.mk_config(opts)
    end

    def check_game_dir?
      return :skip if config.game_dir == false #:game_dir as false is a valid value
      return :dir if config.game_dir.directory? #ok if the path exists and is
                                               # a directory
      raise GameParseError.new("No dir found for :game_dir of #{config.game_dir}")
    end

    def check_game_module?
      runtime.game_module = Module.const_get(config.game_module)
    rescue TypeError, NoMethodError
      raise GameParseError.new("game_module could not be determined from #{config.game_module.inspect}")
    rescue NameError
      raise GameParseError.new("game_module could not be found for '#{config.game_module.to_s.upper_camelcase}'")
    end

    def check_game_class?
      runtime.game_class = runtime.game_module.const_get(config.game_class)
      return runtime.game_class
    rescue TypeError, NoMethodError
      raise GameParseError.new("game_class could not be determined from #{config.game_class.inspect}")
    rescue NameError
      raise GameParseError.new("game_class could not be found for: #{config.game_module}::#{config.game_class}")
    end

    def check_game_maker_class?
      if config.game_maker_class? && config.game_maker_class
        runtime.game_maker_class = runtime.game_module.const_get(config.game_maker_class)
      else
        runtime.game_maker_class = runtime.game_class
      end
    rescue TypeError, NoMethodError
      raise GameParseError.new("game_maker_class could not be determined from #{config.game_maker_class.inspect}")
    rescue NameError
      raise GameParseError.new("game_maker_class could not be found for: #{config.game_module}::#{config.game_maker_class}")
    end
  end
end