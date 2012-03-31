require 'em-websocket'
require_relative 'domain'

# Monkey patch to call a lambda between EM.run and EventMachine.start_server
# The lambda is for initialization, and in my specific case, to kick
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
      @engine.advance
      broadcast
    end
  end
  
  def add_connection(socket)
    puts "Adding a connection to list"
    @connections[socket] = nil
    socket.send 'request_login'
  end
  
  def receive_message(socket, msg)
    user_account = @connections[socket]
    if user_account.nil?
      # Verify that it is a login message, and handle it...
      # we don't have a user account associated yet so we need to get one
      user_account = @engine.attempt_login(msg)
      @connections[socket] = user_account
    else
      user_account.from_client << msg
    end
  end
  
  def remove_connection(socket)
    puts "Client disconnected - removing from list"
    @connections.delete(socket)
  end
  
  def broadcast
    #@accounts.each do |k,v|
    #  puts "#{k.class} #{v.class} "
    #  k.send 'hello?'
    #end
  end
end
