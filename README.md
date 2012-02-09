# Battleship AI

## Overview

After playing battleship on the iPad with my son, I started wondering
about strategy and ways to ensure a win.  This project is the
implementation of various strategies and a system for ranking their
performance against each other.

## Project Components

 * Implementation of the Battleship game rules
 * AI Comparator that uses the [ELO ranking system](http://en.wikipedia.org/wiki/Elo_rating_system)
 * Console based board state printer
 * Various AI implementations listed below

## AI Types

 - **Random Seeker**: Randomly selects cells until it get a hit then
   switches to attack mode to sink the ship
 - **Basic**: Starts at the top and hits every cell until it reaches the
   bottom
 - **Random**: Cells to attack are randomly selected

## Placement Strategies

 - **Random**: Ships are placed randomly on the board in a horizontal or
   vertical position

## AI API

TODO document

## Executing

  bundle install
  ruby runner.rb

## TODO

### AI Type

 - Smart targeting: Only hit cells where a ship could be, attack cells
   the decrease possible locations first
 - Grid based attack
 - Statistical analysis
 - Machine learning or neural network backed AI

### Placement Strategies

 - Random horizontal only
 - Random vertical only
 - Random but never touching
 - Random edges only
 - Random clumped together
