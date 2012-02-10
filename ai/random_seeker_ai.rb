class RandomSeekerAI 
 
  include RandomShipPlacement
  include AIHelpers

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
