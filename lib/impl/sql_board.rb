require 'logger'
require 'sequel'

class SqlBoard
  
  DB = Sequel.sqlite
  WIDTH = 100
  HEIGHT = 100
  
  def initialize
    #DB.loggers << Logger.new($stdout) # Can turn this on for debugging
    wipe
  end
  
  def insert_living_cell(x, y)
    living_cells = DB[:living_cells]
    exists = living_cells.first(:x => x, :y => y)
    
    if exists.nil?
      living_cells.insert(:x => x, :y => y)
    end
  end
  
  def get_living_info
    delta = []
    living_cells = DB[:living_cells]
    living_cells.each do |cell|
      delta << { :x => cell[:x], :y => cell[:y], :action => 'alive' }
    end
    
    delta
  end
  
  def step
    candidate_cells = DB[:candidate_cells]
    candidate_cells.delete
    
    delta = []
    
    # Part 1 - Setup
    # Calculate neighbors for all cells on each
    # side of each living cell
    living_cells = DB[:living_cells]
    living_cells.each do |cell|
      inform_neighbors(cell[:x], cell[:y])
    end
    
    # Part 2 - Death
    # delete from living_cells where not exists the x,y
    # coordinate in candidate_cells where neighbors in (2,3)
    # This could probably be improved upon with set operations
    living_cells.each do |cell|
      existing_cell = candidate_cells.first(:x => cell[:x], :y => cell[:y], :neighbors => [2,3])
      if existing_cell.nil?
        living_cells.where(:x => cell[:x], :y => cell[:y]).delete
        delta << { :x => cell[:x], :y => cell[:y], :action => 'dead' }
      end
    end
    
    # Part 3 - Birth
    # any candidate cells with exactly three neighbors
    # can enter the land of the living (could already be there)
    # This could probably be improved upon with set operations
    candidate_cells.where(:neighbors => 3).each do |cell|
      insert_living_cell(cell[:x], cell[:y])
      delta << { :x => cell[:x], :y => cell[:y], :action => 'alive' } 
    end
    
    delta 
  end
  
  private
  
  def wipe
    DB.drop_table(:living_cells) rescue # do nothing
    DB.drop_table(:candidate_cells) rescue # do nothing
    
    DB.create_table(:living_cells) do
      Integer :x
      Integer :y
      primary_key [:x, :y]
      index [:x, :y], :unique => true
    end
    
    DB.create_table(:candidate_cells) do
      Integer :x
      Integer :y
      Integer :neighbors, :index => true
      primary_key [:x, :y]
      index [:x, :y], :unique => true
    end
    
    # Initial conditions
    r_pentomino(50, 50)
  end
  
  # R-pentomino shape:  XX
  #                    XX
  #                     X
  def r_pentomino(x, y)
    insert_living_cell(x  , y)
    insert_living_cell(x+1, y)
    insert_living_cell(x-1, y+1)
    insert_living_cell(x  , y+1)
    insert_living_cell(x  , y+2)
  end
  
  def upsert_candidate(x, y)
    # Enforce boundary
    return nil if x < 0 || x >= WIDTH || y < 0 || y >= HEIGHT
    
    candidate_cells = DB[:candidate_cells]
    existing_cell = candidate_cells.first(:x => x, :y => y)
    
    if existing_cell.nil?
      candidate_cells.insert(:x => x, :y => y, :neighbors => 1)
    else
      candidate_cells.where(:x => x, :y => y).update(:neighbors => 1 + existing_cell[:neighbors])
    end
  end
  
  def inform_neighbors(x, y)
    upsert_candidate(x-1, y-1)
    upsert_candidate(x  , y-1)
    upsert_candidate(x+1, y-1)
    upsert_candidate(x-1, y)
    upsert_candidate(x+1, y)
    upsert_candidate(x-1, y+1)
    upsert_candidate(x  , y+1)
    upsert_candidate(x+1, y+1)
  end
end
