class BasicBattshipAI 
 
  def initialize(placement)
    @placement = placement
  end

  def ship_positions
    @placement.ship_positions
  end

  def new_game
    @moves = []
  end

  def move
    if @moves.empty?
      return 0, 0
    end

    x, y = @moves.last
    if x == (BattleshipGame::BOARD_SIZE - 1)
      return 0, y + 1
    else
      raise "hit all squares" if y == (BattleshipGame::BOARD_SIZE)
      return x + 1, y
    end
  end

  def move_outcome(outcome)
    unless outcome[:opponents_move]
      @moves << [outcome[:x], outcome[:y]]
    end
  end

  def type
    "Basic"
  end

  def placement_type
    @placement.type
  end
end
