require File.dirname(__FILE__) + '/game/ship'
require File.dirname(__FILE__) + '/util/board_printer'
require File.dirname(__FILE__) + '/game/battleship_game'
require File.dirname(__FILE__) + '/compare/ai_competitor'
require File.dirname(__FILE__) + '/compare/ai_comparator'
require File.dirname(__FILE__) + '/ai/placement/random_ship_placement'
require File.dirname(__FILE__) + '/ai/placement/random_horizontal_placement'
require File.dirname(__FILE__) + '/ai/placement/random_vertical_placement'
require File.dirname(__FILE__) + '/ai/placement/fixed_placement'
require File.dirname(__FILE__) + '/ai/helpers/ai_helpers'
require File.dirname(__FILE__) + '/ai/helpers/attack_helper'
require File.dirname(__FILE__) + '/ai/basic_battleship_ai'
require File.dirname(__FILE__) + '/ai/random_seeker_ai'
require File.dirname(__FILE__) + '/ai/random_seeker_ai_old'
require File.dirname(__FILE__) + '/ai/random_ai'
require File.dirname(__FILE__) + '/ai/smart_seeker_ai'
require File.dirname(__FILE__) + '/ai/grid_seeker_ai'

placements = []
placements << RandomShipPlacement.new
placements << RandomHorizontalPlacement.new
placements << RandomVerticalPlacement.new
placements << FixedPlacement.new

ais = []
placements.each do |placement|
  ais << RandomSeekerAI.new(placement)
  ais << GridSeekerAI.new(placement)
  #ais << RandomSeekerAIOld.new(placement)
  #ais << RandomAI.new(placement)
  #ais << BasicBattshipAI.new(placement)
  ais << SmartSeekerAI.new(placement)
end

comparator = AIComparator.new(ais, 100)
comparator.compare_ais

p "Done"
