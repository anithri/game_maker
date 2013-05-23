require "game_master/version"
require "game_master/config_loader"
require "game_master/game"

class GameParseError < StandardError
end

module GameMaster
  DEFAULT_CONFIG_FILE = File.dirname(__FILE__) +
                        "/../streets_of_gotham/etc/game_config.yml"

  # @param [Hash] opts options to be passed to ConfigLoader.  See ConfigLoader.load for more
  # details
  # @return [Ganme]
  def self.game_from(opts = {})
    config = GameMaster::ConfigLoader.load(opts)
    set_defaults(config)
    check_validity(config)
    mk_game(mk_config(config))
  end

  protected

  #TODO Find a way to genericize this to allow other config stores to be created
  def self.mk_config(raw_config)
    ::Hashery::OpenCascade[raw_config]
  end

  def self.set_defaults(config)
    config[:game_dir] ||= File.dirname(config[:game_config_file]) if config[:game_config_file]
    config[:game_name] ||= File.basename(config[:game_dir]).titlecase if config[:game_dir]
    config[:game_module_name] ||= self.to_s
    config[:game_class_name] ||= "Game"
  end

  def self.check_validity(config)
    check_game_dir    config[:game_dir]
    check_game_module config[:game_module_name], config
    check_game_class  config[:_game_module], config[:game_class_name], config
  end

  def self.mk_game(config)
    config[:_game_class].new(config)
  end

  def self.check_game_dir(dir)
    return dir if game_dir_ok?(dir)
    raise GameParseError.new("Could not determine :game_dir") unless dir
    raise GameParseError.new("No dir found: #{dir}")
  end

  def self.game_dir_ok?(dir)
    ! dir.nil? && File.directory?(dir)
  end

  def self.check_game_module(module_name, config)
    begin
      config[:_game_module] ||=  Module.const_get(module_name)
    rescue NameError
      raise GameParseError.new("Module could not be found: #{module_name}")
    end
  end

  def self.check_game_class(module_name, class_name, config)
    begin
      config[:_game_class] ||= module_name.const_get(class_name)
    rescue
      raise GameParseError.new("Class could not be found: #{module_name}::#{class_name}")
    end
  end
end

