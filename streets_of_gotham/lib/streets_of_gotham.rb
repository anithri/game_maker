require "game_maker"
require_relative 'streets_of_gotham/version'

module StreetsOfGotham
  require_relative 'streets_of_gotham/game'
  def self.game_from(opts = {})
    binding.pry
    opts[:dirname] ||= File.dirname(__FILE__) + '/..'
    GameMaker.game_from(opts)
  end
end

