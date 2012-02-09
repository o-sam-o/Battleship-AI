module AIHelpers

  VALID_CELLS = (0...BattleshipGame::BOARD_SIZE).to_a.product((0...BattleshipGame::BOARD_SIZE).to_a)

  def possible_ship_location?(ship, moves)
    (ship.cells - VALID_CELLS).empty? && (ship.cells - moves) == ship.cells
  end

  def vertical_alignment?(moves)
    moves[0][1] == moves[1][1]
  end

  def above(move)
    [move[0] + 1, move[1]]
  end

  def below(move)
    [move[0] - 1, move[1]]
  end

  def left(move)
    [move[0], move[1] - 1]
  end

  def right(move)
    [move[0], move[1] + 1]
  end

  def remove_invalid(moves, cells_already_hit)
    moves.delete_if { |move| not valid_move?(move, cells_already_hit) }
  end

  def valid_move?(move, cells_already_hit)
    move[0] < BattleshipGame::BOARD_SIZE && move[0] >= 0 &&
      move[1] < BattleshipGame::BOARD_SIZE && move[1] >= 0 && 
      !cells_already_hit.include?(move)
  end

end
