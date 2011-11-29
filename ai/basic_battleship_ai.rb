class BasicBattshipAI 
  
  def new_game
    @moves = []
  end

  def ship_positions
    ships = []
    ships << Ship.new(:aircraft_carrier, 0, 0, :vertical)
    ships << Ship.new(:battleship, 1, 0, :vertical)
    ships << Ship.new(:destoryer, 2, 0, :vertical)
    ships << Ship.new(:submarine, 3, 0, :vertical)
    ships << Ship.new(:patrol_boat, 4, 0, :vertical)

    return ships
  end

  def move
    if @moves.empty?
      return 0, 0
    end

    x, y = @moves.last
    if x == (BattleshipGame::BOARD_SIZE - 1)
      return 0, y + 1
    else
      raise "hit all squares" if y == (BattleshipGame::BOARD_SIZE - 1)
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

end
