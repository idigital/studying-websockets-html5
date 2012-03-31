require_relative 'engine'
require_relative 'net'

class SerenityTech
  def start
    engine = Engine.new
    engine.start
    
    net = Net.new(engine)
    net.start
  end
end
