require File.dirname(__FILE__) + '/../spec_helper'

describe RandomSeekerAI do
  
  it 'should aim for squares near a hit after one is recorded' do
    4.times do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      # Setup hit
      ai.move_outcome(
        :opponents_move => false,
        :x => 5,
        :y => 5,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )

      [[4, 5], [6, 5], [5, 4], [5, 6]].should include(ai.move)
    end
  end

  it 'should ignore squares that are already recorded as hits when seeking' do
    4.times do |count|
      already_miss = case count
                     when 0 then [4, 5]
                     when 1 then [6, 5]
                     when 2 then [5, 4]
                     when 3 then [5, 6]
                     end

      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      # Setup miss
      ai.move_outcome(
        :opponents_move => false,
        :x => already_miss[0],
        :y => already_miss[1],
        :sunk => false,
        :hit => false
      )

      # Setup hit
      ai.move_outcome(
        :opponents_move => false,
        :x => 5,
        :y => 5,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )

      valid_moves = [[4, 5], [6, 5], [5, 4], [5, 6]]
      valid_moves.delete(already_miss)
      valid_moves.should include(ai.move)
    end
  end

  it 'should ignore the edge of the board when a hit is recorded' do
    ai = RandomSeekerAI.new(RandomShipPlacement.new)
    ai.new_game

    # Setup miss
    ai.move_outcome(
      :opponents_move => false,
      :x => 1,
      :y => 0,
      :sunk => false,
      :hit => false
    )

    # Setup hit
    ai.move_outcome(
      :opponents_move => false,
      :x => 0,
      :y => 0,
      :sunk => false,
      :ship_type => :submarine,
      :hit => true
    )

    ai.move.should == [0, 1]
  end

  context 'should target on the same axis if two hits are recorded on the same ship' do
    it 'for horizontal alignment' do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      # Setup hits
      ai.move_outcome(
        :opponents_move => false,
        :x => 5,
        :y => 5,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )
      ai.move_outcome(
        :opponents_move => false,
        :x => 6,
        :y => 5,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )

      [[4,5], [7,5]].should include(ai.move)
    end

    it 'for vertical alignment' do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      # Setup hits
      ai.move_outcome(
        :opponents_move => false,
        :x => 5,
        :y => 5,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )
      ai.move_outcome(
        :opponents_move => false,
        :x => 5,
        :y => 6,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )

      [[5,4], [5,7]].should include(ai.move)
    end
  end

  it 'should not target an axis if there is not enough room for a ship' do
    # Run test multiple times to account for random access selection
    4.times do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      ai.move_outcome(
        :opponents_move => false,
        :x => 2,
        :y => 0,
        :sunk => false,
        :hit => false
      )

      ai.move_outcome(
        :opponents_move => false,
        :x => 0,
        :y => 0,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )

      ai.move.should == [0, 1]
    end
  end

  it 'should return to seek mode after a ship has been sunk' do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      ai.instance_eval { @mode }.should == :random

      ai.move_outcome(
        :opponents_move => false,
        :x => 0,
        :y => 0,
        :sunk => false,
        :ship_type => :patrol_boat,
        :hit => true
      )

      ai.instance_eval { @mode }.should == :attack

      ai.move_outcome(
        :opponents_move => false,
        :x => 1,
        :y => 0,
        :sunk => true,
        :ship_type => :patrol_boat,
        :hit => true
      )

      ai.instance_eval { @mode }.should == :random
  end

  it 'should be able to handle hitting another ship while in attack mode' do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      ai.move_outcome(
        :opponents_move => false,
        :x => 0,
        :y => 0,
        :sunk => false,
        :ship_type => :patrol_boat,
        :hit => true
      )

      ai.move_outcome(
        :opponents_move => false,
        :x => 1,
        :y => 0,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )

      ai.move.should == [0, 1]
  end

  it 'if another ship is found while in attack mode it should attack the second ship once the first is sunk' do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

    ai.move_outcome(
      :opponents_move => false,
      :x => 2,
      :y => 0,
      :sunk => false,
      :hit => false
    )

      ai.move_outcome(
        :opponents_move => false,
        :x => 0,
        :y => 0,
        :sunk => false,
        :ship_type => :patrol_boat,
        :hit => true
      )

      ai.move_outcome(
        :opponents_move => false,
        :x => 1,
        :y => 0,
        :sunk => false,
        :ship_type => :submarine,
        :hit => true
      )

      ai.move_outcome(
        :opponents_move => false,
        :x => 0,
        :y => 1,
        :sunk => true,
        :ship_type => :patrol_boat,
        :hit => true
      )

      ai.instance_eval { @mode }.should == :attack

      ai.move.should == [1, 1]
  end

  context :valid_move? do
    it 'should only return true if move is within the board bounds' do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      ai.send(:valid_move?, [0,0], []).should be_true
      ai.send(:valid_move?, [9,9], []).should be_true
      ai.send(:valid_move?, [-1,0], []).should_not be_true
      ai.send(:valid_move?, [10,0], []).should_not be_true
      ai.send(:valid_move?, [0,-1], []).should_not be_true
      ai.send(:valid_move?, [0,10], []).should_not be_true
    end

    it 'should return false if a move has already been made' do
      ai = RandomSeekerAI.new(RandomShipPlacement.new)
      ai.new_game

      ai.send(:valid_move?, [1,0], [[1,0]]).should_not be_true
      ai.send(:valid_move?, [0,0], [[1,0]]).should be_true
    end
  end
end
