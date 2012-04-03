require 'logger'
require 'json'
require_relative 'mem_board'

class Avatar
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end


class World
  # Runs once at server startup
  def initialize
    @board = MemBoard.new
    @logger = Logger.new(STDOUT)
    @avatars = {}
    @last_time = Time.now
  end
  
  # Runs each tick (tick = approx 3.33ms)
  def advance
    elapsed = Time.now - @last_time
    if (elapsed > 0.033)
      @last_time = Time.now
      delta = @board.step
      
      # Queue the appropriate deltas to the appropriate avatars
      @avatars.each_key do |user_account|
        user_account.send_to_client(delta.to_json)
      end
    end
  end
  
  # Runs for each message queued per tick (tick = approx 3.33ms)
  # Process incoming messages from clients
  def execute(user_account, client_msg)
    obj = JSON.parse(client_msg)
    x = obj['x']
    y = obj['y']
    action = obj['action']
    
    case action
      when 'single'
        @board.insert_living_cell(x, y)
      when 'acorn'
        # Do it
      when 'b_heptomino'
        # Do it
      when 'r_pentomino'
        @board.r_pentomino(x, y)
      when 'bunnies'
        # Do it
      when 'reset'
        # Do it (not yet implemented on client)
      else
        @logger.error "Warning: Received unknown message from client: #{client_msg}"
    end
  end
  
  # Runs each time a client login request is received
  def attempt_login(user_account)
    @logger.info "World: Processing login request for #{user_account.inspect}"
    # TODO: Would need to prevent dupes? Or will the hash always be unique?
    @avatars[user_account] = Avatar.new(user_account.username)
    
    delta = @board.get_living_info
    user_account.send_to_client(delta.to_json)
  end
  
  # Runs when a client is disconnected
  def notify_disconnect(user_account)
    @logger.info "World: Reacting to disconnection of #{user_account.inspect}"
    @avatars.delete(user_account)
  end
  
  def shutdown
    # TODO: Cleanup will go here in the event of graceful shutdown
  end
end