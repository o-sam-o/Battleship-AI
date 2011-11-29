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

  def ship_size
    case @type
    when :aircraft_carrier then 5
    when :battleship then 4
    when :submarine, :destoryer then 3
    when :patrol_boat then 2
    else raise "Unknown ship type '#{@type}'"
    end
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

private

  def hit_ship?(x, y)
    if vertical?
      x == @x && (@y...@y + ship_size).include?(y)
    else
      (@x...@x + ship_size).include?(x) && y == @y
    end
  end

end
