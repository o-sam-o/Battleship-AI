class RandomSeekerAIOld
 
  include AIHelpers

  def initialize(placement)
    @placement = placement
  end

  def new_game
    @moves = []
    @mode = :random
    @attack_prospects = {}
  end

  def ship_positions
    @placement.ship_positions
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
      if current_hits.size < 2
        hit = current_hits[0]
        return remove_invalid([above(hit), below(hit), left(hit), right(hit)], @moves)[0]
      elsif vertical_alignment?(current_hits)
        possible_moves = current_hits.collect do |hit|
          [above(hit), below(hit)]
        end.flatten(1)
        return remove_invalid(possible_moves, @moves)[0]
      else
        possible_moves = current_hits.collect do |hit|
          [left(hit), right(hit)]
        end.flatten(1)
        return remove_invalid(possible_moves, @moves)[0]
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
    "Random Seeker Old"
  end

  def placement_type
    @placement.type
  end

private

  def random_cell
    [rand(BattleshipGame::BOARD_SIZE), rand(BattleshipGame::BOARD_SIZE)]
  end

end
