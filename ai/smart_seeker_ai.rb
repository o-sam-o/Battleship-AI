class SmartSeekerAI

  include RandomShipPlacement
  include AIHelpers

  def new_game
    @moves = []
    @mode = :seek
    @targets = [:aircraft_carrier, :battleship, :destoryer, :submarine, :patrol_boat]
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
    if @mode == :seek
      return seek_move
    else
      return attack_move
    end
  end
 
  def seek_move
    target_ship = @targets.first

    # Find all the possible locations the target ship could be located
    # and all the cells it would overlap
    possible_ship_cells = []
    (VALID_CELLS - @moves).each do |x, y|
      ship = Ship.new(target_ship, x, y, :horizontal)
      possible_ship_cells << ship.cells if possible_ship_location?(ship, @moves)
      ship = Ship.new(target_ship, x, y, :vertical)
      possible_ship_cells << ship.cells if possible_ship_location?(ship, @moves)
    end
    possible_ship_cells.flatten!(1)

    # Reduce the list to the cells with the greatest overlap
    max_count = 0
    target_cells = []
    possible_ship_cells.group_by { |c| c }.each do |cell, count|
      if count.length > max_count
        max_count = count.length
        target_cells = [cell]
      elsif count.length == max_count
        target_cells << cell
      end
    end

    return target_cells.sample
  end 

    def attack_move
      target_ship = @attack_prospects.first[0]
      current_hits = @attack_prospects.first[1]
      if current_hits.size < 2
        hit = current_hits[0]
        return remove_invalid([above(hit), below(hit), left(hit), right(hit)], @moves).sample
      elsif vertical_alignment?(current_hits)
        possible_moves = current_hits.collect do |hit|
          [above(hit), below(hit)]
        end.flatten(1)
        return remove_invalid(possible_moves, @moves).sample
      else
        possible_moves = current_hits.collect do |hit|
          [left(hit), right(hit)]
        end.flatten(1)
        return remove_invalid(possible_moves, @moves).sample
      end
  end

  def move_outcome(outcome)
    unless outcome[:opponents_move]
      @moves << [outcome[:x], outcome[:y]]
      if outcome[:sunk]
        @attack_prospects.delete(outcome[:ship_type])
        @targets.delete(outcome[:ship_type])
        @mode = @attack_prospects.empty? ? :seek : :attack
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
    "Smart Seeker"
  end

end
