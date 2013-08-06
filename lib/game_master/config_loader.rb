require 'hash_deep_merge'
require 'hashery'
require 'yaml'
require 'facets/string/camelcase'
require 'facets/string/titlecase'

module GameMaster
  module ConfigLoader
    autoload :Base, 'game_master/config_loader/base'
    autoload :StageTracker, 'game_master/config_loader/stage_tracker'

    module Stages; end

    STAGE_TRACKER = StageTracker.instance
    DEFAULT_STAGES = [
        ['bootstrap',                 10],
        ['normalize_game_dir',        21],
        ['normalize_game_name',       22],
        ['normalize_game_module',     23],
        ['normalize_game_class',      24],
        ['normalize_game_maker_class',25],
        ['game_loader',               100]
    ]
    def self.load(game, loader, runtime)
      config_loader = Base.new(STAGE_TRACKER)
      config_loader.load(game, loader, runtime)
    end

    def self.require_and_register_default_stages
      DEFAULT_STAGES.each do |stage_array|
        raw_stage, priority = stage_array
        require_relative "config_loader/stages/#{raw_stage}"
        stage_module = GameMaster::ConfigLoader::Stages.const_get(raw_stage.titlecase.gsub(/ /,''))
        stage_array[2] = stage_module
        STAGE_TRACKER.register_stage(stage_module, priority)
      end
    end
  end
end
GameMaster::ConfigLoader.require_and_register_default_stages