require 'terminal-table'

class AIComparator

  def initialize(ais, games_to_play)
    @competitors = ais.collect { |ai| AICompetitor.new(ai) }
    @games_to_play = games_to_play
  end

  def compare_ais
    match_ups = @competitors.repeated_combination(2).to_a
    match_ups.delete_if { |comp_1, comp_2| comp_1 == comp_2 }

    @games_to_play.times do |game_number|
      match_ups.each do |comp_1, comp_2|
        vs comp_1, comp_2, game_number
      end
    end

    print_results
  end

private

  def vs(comp_1, comp_2, game_number)
    game = BattleshipGame.new(comp_1.ai, comp_2.ai, game_number)
    game.run_game

    if game.winner == comp_1.ai
      comp_1.beats(comp_2)
    else
      comp_2.beats(comp_1)
    end
  end

  def print_results
    @competitors.sort!
    table = Terminal::Table.new do |t|
      t.headings = ['AI Type', 'Placement', 'Rating', 'Wins', 'Loses']
      @competitors.each do |comp|
        t << [comp.name, comp.placement_type, comp.rating, comp.wins, comp.loses]
      end
    end
    p table
  end

end
