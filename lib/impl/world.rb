require 'logger'
require_relative 'dao'

class Avatar
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

class World
  # Runs once at server startup
  def initialize
    @logger = Logger.new(STDOUT)
    @avatars = {}
  end
  
  # Runs each tick (tick = approx 33ms)
  # Process incoming messages from daemons
  def advance
  end
  
  # Runs for each message queued per tick (tick = approx 33ms)
  # Process incoming messages from clients
  def execute(user_account, client_msg)
    @logger.info "World: Processing message #{client_msg.inspect} for #{user_account.inspect}"
  end
  
  # Runs each time a client login request is received
  def attempt_login(user_account)
    @logger.info "World: Processing login request for #{user_account.inspect}"
    # TODO: Would need to prevent dupes
    @avatars[user_account] = Avatar.new(user_account.username)
  end
  
  # Runs when a client is disconnected
  def notify_disconnect(user_account)
    @logger.info "World: Reacting to disconnction of #{user_account.inspect}"
    @avatars.delete(user_account)
  end
  
  def shutdown
    # TODO: Cleanup will go here in the event of graceful shutdown
  end
end