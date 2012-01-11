class BasicBattshipAI 
 
  include RandomShipPlacement

  def new_game
    @moves = []
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

end
