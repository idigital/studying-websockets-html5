require_relative 'dao'
require_relative 'net'

class Engine
  include Celluloid
  
  def start
    #
  end
  
  def say_something(msg)
    puts "Hi! #{msg}"
  end
end

class SerenityTech
  def start
    dao = DAO.new
    Celluloid::Actor[:dao] = dao
    dao.start
    
    engine = Engine.new
    Celluloid::Actor[:engine] = engine
    engine.start
    
    net = Net.new
    Celluloid::Actor[:net] = net
    net.start
  end
end
