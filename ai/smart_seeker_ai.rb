class SmartSeekerAI

  include AIHelpers
  include AttackHelper

  def initialize(placement)
    @placement = placement
  end

  def new_game
    @moves = []
    @mode = :seek
    @targets = [:aircraft_carrier, :battleship, :destoryer, :submarine, :patrol_boat]
    @attack_prospects = {}
  end

  def ship_positions
    @placement.ship_positions
  end

  def move
    if @mode == :seek
      return seek_move
    else
      return attack_move(@attack_prospects, @moves)
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

    return select_cell(target_cells)
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

  def placement_type
    @placement.type
  end

end
