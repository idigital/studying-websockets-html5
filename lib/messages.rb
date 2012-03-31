
# From server to client(s)
class ServerMessage
  attr_reader :clients
  attr_reader :obj
end

# From client to server
class ClientMessage
  attr_reader :client
  attr_reader :obj
end