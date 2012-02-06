class BattleshipGame

  BOARD_SIZE = 10

  def initialize(ai_1, ai_2, game_count)
    @ai_1 = ai_1
    @ai_2 = ai_2
    @game_count = game_count
    @score = { ai_1 => 0, ai_2 => 0 } 
    @ships = {}
  end

  def run_games
    @game_count.times do |game_number|
      init_game(game_number)

      until game_over?
        @current_player = not_current_ai
        p "AI #{@current_player == @ai_1 ? 1 : 2} move"
        make_move(@current_player)
      end

      p "Game #{game_number + 1} over AI #{@current_player == @ai_1 ? 1 : 2} of type #{@current_player.type} wins"
      @score[@current_player] += 1
    end

    print_results
  end

  def init_game(game_number)
    p "Starting game #{game_number}"
    @ai_1.new_game
    @ai_2.new_game

    @ships[@ai_1] = ship_positions(@ai_1)
    @ships[@ai_2] = ship_positions(@ai_2)

    # Alternate who starts first
    @current_player = game_number % 2 == 0 ? @ai_1 : @ai_2
  end

  def ship_positions(ai)
    ships = ai.ship_positions
    ships.each do |ship|
      raise "Invalid position #{ship} from ai #{ai.type}" unless ship.valid_placement?
    end
    
    ship_cells = ships.collect { |exist_ship| exist_ship.cells }.flatten(1)
    raise "Ships overlap for ai #{ai.type}" unless ship_cells == ship_cells.uniq

    return ships
  end

  def game_over?
    @ships[@ai_1].detect{ |ship| ship.alive? }.nil? || @ships[@ai_2].detect{ |ship| ship.alive? }.nil? 
  end

  def make_move(ai)
    move_x, move_y = ai.move

    hit_ship = @ships[not_current_ai].detect do |ship|
      ship.hit?(move_x, move_y)
    end

    #p "x: #{move_x} y: #{move_y} hit: #{hit_ship.to_s}"

    move_outcome = {
      :x => move_x, 
      :y => move_y, 
      :hit => hit_ship != nil,
      :sunk => hit_ship && hit_ship.sunk?,
      :ship_type => (hit_ship.type rescue nil)
    }

    @ai_1.move_outcome(move_outcome.merge(:opponents_move => @current_player == @ai_2))
    @ai_2.move_outcome(move_outcome.merge(:opponents_move => @current_player == @ai_1))
  end

  def not_current_ai
    @current_player == @ai_1 ? @ai_2 : @ai_1
  end

  def print_results
    p "All games played"
    p "-" * 20
    if @score[@ai_1] > @score[@ai_2]
      p "AI 1 (#{@ai_1.type}) won in #{@score[@ai_1]} games to #{@score[@ai_2]}"
    elsif @score[@ai_2] > @score[@ai_1]
      p "AI 2 (#{@ai_2.type}) won in #{@score[@ai_2]} games to #{@score[@ai_1]}"
    else
      p "Draw"
    end
  end

end
