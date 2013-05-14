require "game_maker/version"
require "game_maker/config_loader"

class GameParseError < StandardError
end

module GameMaker

  DEFAULT_CONFIG_FILE = File.dirname(__FILE__) +
                        "/../streets_of_gotham/etc/game_config.yml"

  def self.mk_game(game_config_file = DEFAULT_CONFIG_FILE)
    game_config = GameMaker::ConfigLoader.load(game_config_file)
    #game_maker = game_config.game_maker
    #game_maker.mk_game(game_config)
    #StreetsOfGotham::GameMaker.mk_game(game_config)
  end

end

