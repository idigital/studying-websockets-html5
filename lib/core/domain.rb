# From server to client(s)
class ServerMessage
  attr_reader :clients
  attr_reader :obj
end

class UserAccount
  attr_reader :username
  attr_reader :from_client 
  attr_reader :to_client
  
  def initialize(username)
    @username = username
    @from_client = []
    @to_client = []
    
    puts "Test: #{username} created"
  end
  
  def to_client_clear
    to_client.clear
  end
  
  def from_client_clear
    from_client.clear
  end
end