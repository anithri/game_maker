require 'rspec'
require 'stringio'
require 'game_master'
require 'game_master/null_logger'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.before(:all) do
    Yell.new :null_logger, name: "GameMaster"
  end
end

Dir["./spec/support/**/*.rb"].each {|f| require f}

TEST_GAME_DIR = Pathname(File.dirname(__FILE__)) + "support/test_game"
TEST_GAME_CONFIG_FILE = TEST_GAME_DIR + "game_config.yml"
TEST_GAME_YAML_STRING = File.read(TEST_GAME_CONFIG_FILE)

module ::TestGame
  class Game
    include GameMaster::Master
  end
  class GameMaker
  end
end

module TestGameNoMaker
  class TestGame
    include GameMaster::Master
  end
end
