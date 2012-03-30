require_relative 'engine'
require_relative 'net'

class SerenityTech
  def start
    engine = Engine.new
    Celluloid::Actor[:engine] = engine
    engine.start
    
    net = Net.new
    Celluloid::Actor[:net] = net
    net.start
  end
end
