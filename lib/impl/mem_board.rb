class MemBoard
  WIDTH = 100
  HEIGHT = 100
  
  def initialize
    @game = Game.new(WIDTH, HEIGHT)
  end
  
  def insert_living_cell(x, y)
    return if x < 0 || x >= WIDTH || y < 0 || y >= HEIGHT
    
    @game.manual_set_alive(x,y)
  end
  
  def get_living_info
    @game.get_all_alive
  end
  
  def step
    @game.next!
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
  
  private
end

## The rest of this file is based on code I found here:
## http://bjorkoy.com/2010/05/conways-game-of-life-in-ruby/
##
## Few changes were needed to integrate it into the mem board.
## Note also that this differs from the sql board in that
## the world wraps around (see the modulus stuff at the end)

class Cell
  attr_writer :neighbors
  attr_accessor :alive
  
  def initialize
    @alive = false
  end
  
  def next!
    @alive = @alive ? (2..3) === @neighbors : 3 == @neighbors
    to_i
  end
  
  def to_i
    @alive ? 1 : 0
  end
  
  def to_s
    @alive ? 'o' : ' '
  end
end

class Game
  def initialize(width, height)
    @width, @height = width, height
    @cells = Array.new(height) { Array.new(width) { Cell.new } }
  end
  
  def manual_set_alive(x,y)
    @cells[y][x].alive = true
  end
  
  def get_all_alive
    delta = []
    
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell.alive
          delta << { :x => x, :y => y, :action => 'alive' }
        end
      end
    end
    
    delta
  end
  
  def next!
    delta = []
    
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.neighbors = alive_neighbors(y, x)
      end
    end
    
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        prev_state = cell.to_i
        new_state = cell.next!
        
        if prev_state == 0 && new_state == 1
          delta << { :x => x, :y => y, :action => 'alive' }
        elsif prev_state == 1 && new_state == 0
          delta << { :x => x, :y => y, :action => 'dead' }
        end
      end
    end
    
    delta
  end
  
  def alive_neighbors(y, x)
    [[-1,  1], [0,  1], [1,  1],  # over
     [-1,  0],          [1,  0],  # sides
     [-1, -1], [0, -1], [1, -1]   # under
    ].inject(0) do |sum, pos|
      sum + @cells[(y + pos[0]) % @height][(x + pos[1]) % @width].to_i
    end
  end
end












