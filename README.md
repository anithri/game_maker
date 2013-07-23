# GameMaker
GameMaker is an attempt to use programnming as a board game design tool.
With an eye towards arranging things such that testing of game rules,
assembling a game into another medium like a rulebook or a game board,
and to allowing it to be used as the game engine of a computer game.

## Sample Board Game:  Streets of Gotham
I'll eventually get all of the GameMaker pieces here,
and all of the StreetsOfGotham parts into the README in the directory,
forgive the jumble while it lasts.  The Game definition file will be used in
some levels of testing.

##Overview
GameMaker is a framework for Game definitions.  Given a configuration file,
the core functionality is GameMaker.mk_game which will compile the
configuration into a working Game file.

##Planned Features
* Generators to create Game directories in a manner similar to ruby gems. And
 that can be used to extend game definitions.
* Using document definition files, output the components of the game into
appropriate parts.  A PDF for rules and cards, maybe a img file for each
game_part.
* Provide convention and methods to allow the resulting game file to be
"played"
* Provide methods to test game componets.  For instance,
if I have a deck of 90 cards, and some combination of 4 different players
from among 6 sources, how often can each card/player combination produce a
success.  Should help balancing games with more complex rules.

## License
GameMaster is released under the [MIT License](http://www.opensource.org/licenses/MIT).
