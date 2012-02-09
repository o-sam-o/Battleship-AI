require File.dirname(__FILE__) + '/game/ship'
require File.dirname(__FILE__) + '/util/board_printer'
require File.dirname(__FILE__) + '/game/battleship_game'
require File.dirname(__FILE__) + '/compare/ai_competitor'
require File.dirname(__FILE__) + '/compare/ai_comparator'
require File.dirname(__FILE__) + '/ai/random_ship_placement'
require File.dirname(__FILE__) + '/ai/basic_battleship_ai'
require File.dirname(__FILE__) + '/ai/random_seeker_ai'
require File.dirname(__FILE__) + '/ai/random_ai'

ais = []
ais << RandomSeekerAI.new
ais << RandomAI.new
ais << BasicBattshipAI.new

comparator = AIComparator.new(ais, 10)
comparator.compare_ais

p "Done"
