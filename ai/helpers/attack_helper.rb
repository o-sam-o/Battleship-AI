module AttackHelper

  def attack_move(attack_prospects, moves)
      target_ship = attack_prospects.first[0]
      current_hits = attack_prospects.first[1]
      hit = current_hits[0]

      target_cells = []
      if (current_hits.size >= 2 && vertical_alignment?(current_hits)) || 
        (current_hits.size == 1 && ship_orientation_possible?(hit[0], hit[1], target_ship, :vertical, moves))
        current_hits.each do |cell|
          target_cells << above(cell)
          target_cells << below(cell)
        end
      elsif (current_hits.size >= 2 && !vertical_alignment?(current_hits)) || 
        (current_hits.size == 1 && ship_orientation_possible?(hit[0], hit[1], target_ship, :horizontal, moves))
        current_hits.each do |cell|
          target_cells << left(cell)
          target_cells << right(cell)
        end
      end

      return remove_invalid(target_cells, moves).sample
  end

  #TODO refactor
  def ship_orientation_possible?(x, y, target_ship, orientation, moves)
    cell = [x, y]
    available_cells = []
    while cell[0] >=0 && cell[0] < BattleshipGame::BOARD_SIZE &&
          cell[1] >=0 && cell[1] < BattleshipGame::BOARD_SIZE &&
          (!moves.include?(cell) || cell == [x,y])
      available_cells << cell
      if orientation == :vertical
        cell = above(cell)
      else
        cell = right(cell)
      end
    end

    cell = [x, y]
    while cell[0] >=0 && cell[0] < BattleshipGame::BOARD_SIZE && 
          cell[1] >=0 && cell[1] < BattleshipGame::BOARD_SIZE &&
          (!moves.include?(cell) || cell == [x,y])
      available_cells << cell
      if orientation == :vertical
        cell = below(cell)
      else
        cell = left(cell)
      end
    end
    available_cells.uniq!

    return available_cells.length >= Ship.ship_size(target_ship)
  end

end
