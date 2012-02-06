class RandomSeekerAI 
 
  include RandomShipPlacement

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
      return attack_move
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

  def attack_move
      target_ship = @attack_prospects.first[0]
      current_hits = @attack_prospects.first[1]
      p "Targeting #{target_ship}"
      if current_hits.size < 2
        hit = current_hits[0]
        return remove_invalid([above(hit), below(hit), left(hit), right(hit)])[0]
      elsif vertical_alignment?(current_hits)
        p current_hits.inspect
        possible_moves = current_hits.collect do |hit|
          [above(hit), below(hit)]
        end.flatten(1)
        return remove_invalid(possible_moves)[0]
      else
        possible_moves = current_hits.collect do |hit|
          [left(hit), right(hit)]
        end.flatten(1)
        return remove_invalid(possible_moves)[0]
      end
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

  def remove_invalid(moves)
    moves.delete_if { |move| not valid_move?(move) }
  end

  def valid_move?(move)
    move[0] < BattleshipGame::BOARD_SIZE && move[0] >= 0 &&
      move[1] < BattleshipGame::BOARD_SIZE && move[1] >= 0 && 
      !@moves.include?(move)
  end

  def random_cell
    [rand(BattleshipGame::BOARD_SIZE), rand(BattleshipGame::BOARD_SIZE)]
  end

end
