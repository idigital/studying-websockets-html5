require 'em-websocket'

class UserAccount
  attr_reader :username
end

# Monkey patch to call a lambda between EM.run and EventMachine.start_server
# The lambda is primary for initialize, which in my specific case, to kick
# off an EventMachine timer. Not sure if there is a better way to do this.
module EventMachine::WebSocket
  def self.start(call_me_first, options, &blk)
    EM.epoll
    EM.run do
      
      trap("TERM") { stop }
      trap("INT") { stop }
      
      call_me_first.call # <-- The new thing
      
      EventMachine::start_server(options[:host], options[:port],
        EventMachine::WebSocket::Connection, options) do |c|
        blk.call(c)
      end
    end
  end
end

class Net
  
  def initialize(engine)
    @engine = engine
    @connections = {}
  end
  
  def start
    EventMachine::WebSocket.start(-> { before_start_server }, :host => 'localhost', :port => 9292) do |socket|
      socket.onopen { add_connection(socket) }
      socket.onmessage { |msg| receive_message(socket, msg) }
      socket.onclose { remove_connection(socket) }
    end
  end
  
  private
  
  def before_start_server
    EventMachine::set_quantum(33) # for 30 fps
    
    @timer = EventMachine::PeriodicTimer.new(0.0333) do
      messages = @engine.advance
      broadcast(messages)
    end
  end
  
  def add_connection(socket)
    puts "Adding a connection to list"
    @connections[socket] = nil
  end
  
  def receive_message(socket, msg)
    @engine.from_client(msg)
  end
  
  def remove_connection(socket)
    puts "Client disconnected - removing from list"
    @connections.delete(socket)
  end
  
  def broadcast(messages)
    #@accounts.each do |k,v|
    #  puts "#{k.class} #{v.class} "
    #  k.send 'hello?'
    #end
  end
end
