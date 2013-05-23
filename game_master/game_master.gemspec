# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'game_master/version'

Gem::Specification.new do |spec|
  spec.name          = "game_master"
  spec.version       = GameMaster::VERSION
  spec.authors       = ["Scott M Parrish"]
  spec.email         = ["anithri@gmail.com"]
  spec.description   = %q{Game Master is an attempt to use programming as a board game design tool
.  With an eye towards arranging things such that testing of game rules, assembling a game into another medium like a rulebook or a game board, and to allowing it to be used as the game engine of a computer game.}
  spec.summary       = %q{Batman Mashup game as programming experiment and game design excercise}
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "hashery"
  spec.add_dependency "facets"
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
