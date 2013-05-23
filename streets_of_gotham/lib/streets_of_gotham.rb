require "game_master"
require_relative 'streets_of_gotham/version'
require_relative 'streets_of_gotham/game'

module StreetsOfGotham
  def self.game_from(opts)
    opts[:dirname] ||= File.dirname(__FILE__) + '/..'
    GameMaster.game_from(opts)
  end
end

