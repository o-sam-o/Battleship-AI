class Ship

  SHIP_TYPES = [:aircraft_carrier, :battleship, :destoryer, :submarine, :patrol_boat]
  ORIENTATIONS = [:horizontal, :vertical]

  attr_accessor :type, :x, :y, :orientation

  def initialize(type, x, y, orientation)
    @type = type
    @x = x
    @y = y
    @orientation = orientation
    @hits = []
  end

  def self.ship_size(type)
    case type
    when :aircraft_carrier then 5
    when :battleship then 4
    when :submarine, :destoryer then 3
    when :patrol_boat then 2
    else raise "Unknown ship type '#{@type}'"
    end
  end

  def ship_size
    Ship.ship_size(@type)
  end

  def hit?(x, y)
    if hit_ship?(x, y)
      @hits << [x, y]
      p "Hit #{@hits.size} for #{@type}"
      p "#{@type} sunk" if sunk?
      return true
    else
      return false
    end
  end

  def sunk?
    @hits.size == ship_size
  end

  def vertical?
    @orientation == :vertical
  end

  def alive?
    !sunk?
  end

  def valid_placement?
    if vertical?
      @x < BattleshipGame::BOARD_SIZE && (@y + ship_size) < BattleshipGame::BOARD_SIZE
    else
      (@x + ship_size) < BattleshipGame::BOARD_SIZE && @y < BattleshipGame::BOARD_SIZE
    end
  end

  def cells
    if vertical?
      (@y...(@y + ship_size)).collect { |y_cell| [@x, y_cell] }
    else
      (@x...(@x + ship_size)).collect { |x_cell| [x_cell, @y] }
    end
  end

  def to_s
    @type
  end

private

  def hit_ship?(x, y)
    if vertical?
      x == @x && (@y...@y + ship_size).include?(y)
    else
      (@x...@x + ship_size).include?(x) && y == @y
    end
  end

end
