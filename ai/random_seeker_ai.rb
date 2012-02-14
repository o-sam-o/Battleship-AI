class RandomSeekerAI 
 
  include RandomShipPlacement
  include AIHelpers
  include AttackHelper

  def new_game
    @moves = []
    @mode = :random
    @attack_prospects = {}
  end

  def ship_positions
    ships = []
    ships << random_ship_location(:aircraft_carrier, ships)
    ships << random_ship_location(:battleship, ships)
    ships << random_ship_location(:destoryer, ships)
    ships << random_ship_location(:submarine, ships)
    ships << random_ship_location(:patrol_boat, ships)

    return ships
  end

  def move
    if @mode == :random
      return random_move
    else
      return attack_move(@attack_prospects, @moves)
    end
  end

  def random_move
      move = random_cell
      #TODO make this more efficient
      while @moves.include?(move)
        move = random_cell
      end
      return move
  end

  def move_outcome(outcome)
    unless outcome[:opponents_move]
      @moves << [outcome[:x], outcome[:y]]
      if outcome[:sunk]
        @attack_prospects.delete(outcome[:ship_type])
        @mode = @attack_prospects.empty? ? :random : :attack
      elsif outcome[:hit]
        @mode = :attack
        unless @attack_prospects[outcome[:ship_type]]
          @attack_prospects[outcome[:ship_type]] = []
        end
        @attack_prospects[outcome[:ship_type]] << [outcome[:x], outcome[:y]]
      end
    end
  end

  def type
    "Random Seeker"
  end

private

  def random_cell
    [rand(BattleshipGame::BOARD_SIZE), rand(BattleshipGame::BOARD_SIZE)]
  end

end
