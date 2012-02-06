require File.dirname(__FILE__) + '/spec_helper'

describe Ship do
  context :hit do
    it "should return a hit if passed ships x and y position" do
      ship = Ship.new(:aircraft_carrier, 0, 0, :vertical)
      ship.hit?(0, 0).should be_true
    end

    it "should return false if passed coords not near ship" do
      ship = Ship.new(:aircraft_carrier, 0, 0, :vertical)
      ship.hit?(100, 100).should be_false
    end

    it "should return a hit if passed aircraft carrier second location" do
      ship = Ship.new(:aircraft_carrier, 0, 0, :vertical)
      ship.hit?(0, 1).should be_true
    end

    it "should return false if passed aircraft carrier second location but wrong orientation" do
      ship = Ship.new(:aircraft_carrier, 0, 0, :horizontal)
      ship.hit?(0, 1).should be_false
    end

    it "should return a hit if passed aircraft carrier second location in horizontal position" do
      ship = Ship.new(:aircraft_carrier, 0, 0, :horizontal)
      ship.hit?(1, 0).should be_true
    end

    it "should return a hit if passed aircraft carrier last location" do
      ship = Ship.new(:aircraft_carrier, 0, 0, :vertical)
      ship.hit?(0, 4).should be_true
    end

    it "should return a false if passed one passed an aircraft carrier last location" do
      ship = Ship.new(:aircraft_carrier, 0, 0, :vertical)
      ship.hit?(0, 5).should be_false
    end

    it "should return a false if passed one passed an patrol boats last location" do
      ship = Ship.new(:patrol_boat, 0, 0, :horizontal)
      ship.hit?(2, 0).should be_false
    end

    it "should return a hit if passed aircraft carrier second location and not top corner" do
      ship = Ship.new(:aircraft_carrier, 6, 10, :vertical)
      ship.hit?(6, 11).should be_true
    end

    it "should return a hit if passed aircraft carrier second location in horizontal position and not in top corner" do
      ship = Ship.new(:aircraft_carrier, 10, 10, :horizontal)
      ship.hit?(11, 10).should be_true
    end
  end

  context :sunk? do
    it "shoud return false if no hits" do
      ship = Ship.new(:patrol_boat, 0, 0, :horizontal)
      ship.should_not be_sunk
    end

    it "should return false if hit once" do
      ship = Ship.new(:patrol_boat, 0, 0, :horizontal)
      ship.hit?(0, 0).should be_true
      ship.should_not be_sunk
    end

    it "should return true if all points hit" do
      ship = Ship.new(:patrol_boat, 0, 0, :vertical)
      ship.hit?(0, 0).should be_true
      ship.hit?(0, 1).should be_true
      ship.should be_sunk
    end
  end

  context :valid_placement? do
    it 'should return true if ship on board' do
      ship = Ship.new(:patrol_boat, 0, 0, :horizontal)
      ship.should be_valid_placement
    end

    it 'should return false if ship off the board' do
      ship = Ship.new(:patrol_boat, 11, 11, :horizontal)
      ship.should_not be_valid_placement
    end

    it 'should return true if ship on board on edge horizontal' do
      ship = Ship.new(:patrol_boat, 7, 9, :horizontal)
      ship.should be_valid_placement
    end

    it 'should return false if just over the edge horizontal' do
      ship = Ship.new(:patrol_boat, 8, 9, :horizontal)
      ship.should_not be_valid_placement
    end

    it 'should return false if just over the edge vertical' do
      ship = Ship.new(:patrol_boat, 9, 8, :vertical)
      ship.should_not be_valid_placement
    end

  end

  describe :cells do
    it 'should return all the cells a ship occupies for horizontal' do
      ship = Ship.new(:patrol_boat, 0, 0, :horizontal)
      ship.cells.should == [[0, 0], [1, 0]]
    end
    it 'should return all the cells a ship occupies for vertical' do
      ship = Ship.new(:submarine, 0, 0, :vertical)
      ship.cells.should == [[0, 0], [0, 1], [0, 2]]
    end
  end
end
