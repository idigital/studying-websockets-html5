require 'rubygems'
require 'bundler/setup'

require 'em-websocket'
require 'eventmachine'

class ChatRoom
  
  def initialize
    @clients = {}
  end
  
  def start(opts={})
    EventMachine::WebSocket.start(opts) do |websocket|
      websocket.onopen { handle_open(websocket) }
      websocket.onmessage { |msg| handle_message(websocket, msg) }
      websocket.onclose { handle_close(websocket) }
    end
  end
  
  def handle_open(websocket)
    puts "Open #{websocket.inspect} "
  end
  
  def handle_message(websocket, msg)
    puts "Message: #{msg}"
  end
  
  def handle_close(websocket)
    puts "Close #{websocket.inspect}"
  end
end

chatroom = ChatRoom.new
chatroom.start(:host => "", :port => "9292")
