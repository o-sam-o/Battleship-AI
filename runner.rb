require File.dirname(__FILE__) + '/ship'
require File.dirname(__FILE__) + '/battleship_game'
require File.dirname(__FILE__) + '/ai/random_ship_placement'
require File.dirname(__FILE__) + '/ai/basic_battleship_ai'

ai_1 = BasicBattshipAI.new
ai_2 = BasicBattshipAI.new

game = BattleshipGame.new(ai_1, ai_2, 1000)

game.run_games

p "Done"
