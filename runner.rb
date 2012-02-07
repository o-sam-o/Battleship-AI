require File.dirname(__FILE__) + '/ship'
require File.dirname(__FILE__) + '/board_printer'
require File.dirname(__FILE__) + '/battleship_game'
require File.dirname(__FILE__) + '/ai/random_ship_placement'
require File.dirname(__FILE__) + '/ai/basic_battleship_ai'
require File.dirname(__FILE__) + '/ai/random_seeker_ai'
require File.dirname(__FILE__) + '/ai/random_ai'

ai_1 = BasicBattshipAI.new
ai_2 = RandomAI.new

game = BattleshipGame.new(ai_1, ai_2, 1)

game.run_games

p "Done"
