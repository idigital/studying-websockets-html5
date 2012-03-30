require_relative 'dao'

class Engine
  include Celluloid
  
  def start
    @dao = DAO.new
  end
  
  def say_something(msg)
    puts "Hi! #{msg}"
  end
end