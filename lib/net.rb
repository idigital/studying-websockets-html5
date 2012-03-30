require 'em-websocket'
require 'celluloid'

class Client
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end
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
  include Celluloid
  
  def initialize
    @clients = {}
  end
  
  def start
    EventMachine::WebSocket.start(-> { before_start_server }, :host => 'localhost', :port => 9292) do |socket|
      socket.onopen { add_client(socket) }
      socket.onmessage { |msg| handle_message(socket, msg) }
      socket.onclose { remove_client(socket) }
    end
  end
  
  private
  
  def before_start_server
    engine = Celluloid::Actor[:engine]
    
    @timer = EventMachine::PeriodicTimer.new(5) do
      engine.say_something! "the time is #{Time.now} with #{@clients.size} clients"
      @clients.each do |k,v|
        puts "#{k.class} #{v.class} "
        k.send 'hello?'
      end
    end
  end
  
  def add_client(socket)
    puts "Adding a client"
    client = Client.new("User #{rand}")
    @clients[socket] = client
  end
  
  def handle_message(socket, message)
    puts "Received a message"
    socket.send 'Hi to you too!'
    @clients.each do |k,v|
      if k != socket
        k.send 'Someone said hi!'
      end
    end
  end
  
  def remove_client(socket)
    puts "Disconnecting a client"
    @clients.delete(socket)
  end
end
