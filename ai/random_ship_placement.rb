module RandomShipPlacement

  def random_ship_location(ship_type, ships)
    orientation = random_orientation
    ship = Ship.new(ship_type, 
                    random_position(orientation == :horizontal ? Ship.ship_size(ship_type) : 0),
                    random_position(orientation == :horizontal ? 0 : Ship.ship_size(ship_type)),
                    orientation)

    # Make sure no overlaps
    existing_cells = ships.collect { |exist_ship| exist_ship.cells }.flatten(1)
    ship = random_ship_location(ship_type, ships) unless (existing_cells & ship.cells).empty?
    
    return ship
  end

  def random_orientation
    rand(2) == 0 ? :horizontal : :vertical
  end

  def random_position(offset)
    rand(BattleshipGame::BOARD_SIZE - offset)
  end

end
