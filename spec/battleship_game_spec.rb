require File.dirname(__FILE__) + '/spec_helper'

describe BattleshipGame do

  context :game_over? do

    before(:each) do
      @ai_1 = stub('ai1')
      @ai_2 = stub('ai2')

      @game = BattleshipGame.new(@ai_1, @ai_2, 1)
    end

    it "should return false if no ships hit" do
      alive_ship = stub('alive ship')
      alive_ship.stub(:alive?).and_return(true)


      @game.instance_eval do
        @ships = { @ai_1 => [alive_ship], @ai_2 => [alive_ship] }
      end

      @game.should_not be_game_over
    end 

    it "should return true if all ships sunk" do
      alive_ship = stub('alive ship')
      alive_ship.stub(:alive?).and_return(true)
      sunk_ship = stub('sunk ship')
      sunk_ship.stub(:alive?).and_return(false)

      @game.instance_eval do
        @ships = { @ai_1 => [alive_ship], @ai_2 => [sunk_ship] }
      end

      @game.should be_game_over
    end 

    it "should return false if any ships alive" do
      alive_ship = stub('alive ship')
      alive_ship.stub(:alive?).and_return(true)
      sunk_ship = stub('sunk ship')
      sunk_ship.stub(:alive?).and_return(false)

      @game.instance_eval do
        @ships = { @ai_1 => [sunk_ship, sunk_ship, sunk_ship, alive_ship], @ai_2 => [sunk_ship, alive_ship, alive_ship, alive_ship] }
      end

      @game.should_not be_game_over
    end 
  end

end
