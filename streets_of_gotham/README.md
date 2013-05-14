# StreetsOfGotham
Streets of Gotham is an attempt to use programnming as a board game design tool.
With an eye towards arranging things such that testing of game rules,
assembling a game into another medium like a rulebook or a game board,
and to allowing it to be used as the game engine of a computer game.

## Board Game Design
I decided that I wanted to design a board game, perhaps many.  I decided that a
good next step would be to mod an existing game.  I've been playing a lot of
cooperative games and of those, two I'm particularly fond of are #TODO MAKE
LINKS# Elder Signs and Star Trek:Expeditions.

Elder Signs (Fantasy Flight Games) is a dice rolling game where you are
trying to accumulate Elder Signs by accomplishing various tasks before a
Great Old God (Cthulu for instance) wakes up an destroys the world.

Star Trek Expeditions is a action taking game where you have a limited number
of actions that you may take from a variety, where you are trying to
simultaenously solve 3 story based tasks before time runs out or the Klingon
in orbit blows up the enterprise.

And I love Batman.  So those are the three main influences for the game I'm
designing.

I'm aware of the copyright issues with batman, so I'm going to be very
careful.  I hope to be able to compeltely extract the Batman elements sooner
than later, and provide a generic stand in for the sample data files.

## Game Design Tool
I'm designing the game along with the design tool at the same time.  This
inevitably leads to a binding of the game to the tool which is how I don't
want the code to be burdened with when I am done. So I'm trying to be very
careful and extemly modular when it comes to laying things out.  THis is a
work in progress and the strict adherence wil rise and fall.  Eventually I
want to have this become a tool that takes a series of definition files and
spits out a rule book, or a series of game components,
or the heart of a computer game (Mostly I envision that as a computer game
equivilent of a game you could play with your friends around a table.)

For now I'm focusing it on the shorter term though.
Things to think about: Shared Config methods, Logger, Observers, Validating

## Game Parts
### Game
This is the basic object, and will be both container and starter of the game.

I'm conentrating on the container and parts until I have enough to warrant
thinking deeper on the abilities of the game object.

It's important that the Definiton files be human readable, writable,
and as explicit as necessary


### GameMaker
This is a ruby element that responds to a .mk_game message.  I'm starting
with it as a module.  In the end I'd like this module to take a definition
file (we'll be talking a lot about those), and based on it know what it has
to load, calculate, randomize and insert into the Game Object.  This is a
definite key to being able to generate vastly different types of games.

### Board
My Game needs a Game Board because moving around and investigating is at the
heart of the thematic elements of the game.

Boards in my Game need to contain Positions.  A Board needs to be able to
return any position by address.  They need to have random elements so that
the game board can be randomized which for a game such as I have in mind
provides a much needed element of novelty to ean game.

Boards should be able to accept additions, subtractions,
and in places changes to reflect a dynamic board.  A board does not need to
do these things unless the BoardMaker asks it too.

This is the first element I can see being further genericized.  Can a game
board reliant on little more than what it's position is, what color it is,
and what piece it contains be modeled identiaclly to a deck of cards?  I
don't know yet so I'm erring on the side of ease and making this a Board for
now.

### BoardMaker

Similar to a GameMaker but concentrating on the board.

Here's what I need for the first iteration of my game.  I need a hex map that
has a 3 rings of hexes around a single location. The center hex will be a
fixed tile.  9 sets of 2 hex tiles will be randomly placed into onto this
board.  3 1 hex tiles will be randomly spread out in the outer ring.  I want
a fixed hex grid, a layout randomly selected, then the tiles spread out
randomly based on that layout. I need all of this to be loaded and the
initializers for the various sub objects loaded by passing it a hash of data.

### Map
I need a Map object which provides a name and a list of MapPositions.  The
map should be able to retrieve a specific Position based on a univeral
identifier called the coordinate.

### MapPosition
I need a map object that has a coordinate, an array of coordinates that they
physically border.  The coordinates do not have to be contiguous,
but should be unique.

