class RandomAI
  include RandomShipPlacement

  def new_game
    @moves = (0...BattleshipGame::BOARD_SIZE).to_a.product((0...BattleshipGame::BOARD_SIZE).to_a)
    @moves.shuffle!
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
    @moves.pop
  end

  def move_outcome(outcome)
    # NOOP
  end

  def type
    "Random"
  end
end

