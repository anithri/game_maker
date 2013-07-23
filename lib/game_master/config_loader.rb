require 'hash_deep_merge'
require 'hashery'
require 'yaml'
require 'facets/string/camelcase'
require 'facets/string/titlecase'

module GameMaster
  module ConfigLoader
    autoload :FirstStage,  'game_master/config_loader/first_stage'
    autoload :SecondStage, 'game_master/config_loader/second_stage'
    autoload :ThirdStage,  'game_master/config_loader/third_stage'
    autoload :FourthStage, 'game_master/config_loader/fourth_stage'

    RESERVED_KEYS = [:game_dir, :game_name, :game_config_file, :game_module_name,
                     :game_maker_class_name, :game_class_name]

    # @param [Hash] opts options to be passed to ConfigLoader  Config loader will use the first of
    #   the four opts listed that it finds and ignore the other 3
    # @option opts [String]  :filename    the name of a game config file
    # @option opts [dirname] :dirname     the name of the top directory of your game
    # @option opts [String]  :yaml_string the string containing the yaml for config
    # @option opts [#read]   :io           an object to read yaml from
    # @param [Hash] config hash containing config data used to initialize GameMAster::Config object
    # @param [Hash] game hash containing game data used to initialize GameMAster::Config object
    def self.load(opts, config = {}, game = {})
      config = GameMaster::Config.new({},config,game,{})

      config.boot.load_opts = opts
      config.boot.first_stage_config = config
      config.boot.first_stage_game = game
      GameMaster::ConfigLoader::FirstStage. load(opts, config) #Load game_config.yml
      #GameMaster::ConfigLoader::SecondStage.load(opts, config) #set defaults
      #GameMaster::ConfigLoader::ThirdStage. load(opts, config) #validity check and runtime options set
      #GameMaster::ConfigLoader::FourthStage.load(opts, config) #load game_data from game_dir
      config
    end

  end
end