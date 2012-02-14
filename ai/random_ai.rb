class RandomAI

  def initialize(placement)
    @placement = placement
  end

  def new_game
    @moves = (0...BattleshipGame::BOARD_SIZE).to_a.product((0...BattleshipGame::BOARD_SIZE).to_a)
    @moves.shuffle!
  end

  def ship_positions
    @placement.ship_positions
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

  def placement_type
    @placement.type
  end
end

