require_relative 'core/engine'
require_relative 'core/net'

class SerenityTech
  def start
    engine = Engine.new
    engine.start
    
    net = Net.new(engine)
    net.start
  end
end
