class GridSeekerAI < SmartSeekerAI

  PREFERED_CELLS = [1, 3, 5, 7, 9].product([1, 3, 5, 7, 9])
 
  def select_cell(cells)
    return (PREFERED_CELLS & cells).sample || cells.sample
  end

  def type
    "Grid Seeker"
  end

end
