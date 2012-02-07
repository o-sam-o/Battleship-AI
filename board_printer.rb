require 'terminal-table'
require 'term/ansicolor'

class String
  include Term::ANSIColor
end

class BoardPrinter 

  def print(ai_1, ai_1_ships, ai_2, ai_2_ships)
    table = Terminal::Table.new do |t| 
      # ascicolor and terminal-table dont seem to play together well so we have to fix the width
      t.style = {:width => 97}
      t << ["AI 1 (#{ai_1.type})", "AI 2 (#{ai_2.type})"]
      t << :separator
      t << [ships_table(ai_1_ships), ships_table(ai_2_ships)]
    end
    p table
  end

private

  def ships_table(ships)
    ship_cells = {}
    ships.each do |ship|
      ship.cells.each do |cell|
        ship_cells[cell] = ship.type.to_s[0].upcase.bold
      end
    end

    table = Terminal::Table.new do |t| 
      t << ['', *(0...BattleshipGame::BOARD_SIZE).to_a]
      (0...BattleshipGame::BOARD_SIZE).each do |y|
        t << :separator
        t << [y, *(0...BattleshipGame::BOARD_SIZE).collect { |x| ship_cells[[x, y]] || '' }]
      end
    end
    return table
  end

end
