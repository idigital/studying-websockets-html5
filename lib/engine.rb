require_relative 'dao'

class Engine
  
  def start
    @dao = DAO.new
  end
  
  def advance
    #
  end
  
  def from_client(msg)
    puts "Message from client: #{msg}"
  end
end