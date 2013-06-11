require 'rspec'
require 'streets_of_gotham'
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
