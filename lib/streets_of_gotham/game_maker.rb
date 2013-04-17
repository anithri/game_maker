module StreetsOfGotham
  module GameMaker
    def self.mk_game
      board = StreetsOfGotham::BoardMaker.mk_board
      StreetsOfGotham::Game.new(board)
    end
  end
end