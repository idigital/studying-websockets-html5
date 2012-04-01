require 'logger'
require_relative 'dao'

class Avatar
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

class World
  def initialize
    @logger = Logger.new(STDOUT)
    @avatars = {}
  end
  
  def advance
  end
  
  def execute(user_account, client_msg)
    @logger.info "World: Processing message #{client_msg.inspect} for #{user_account.inspect}"
  end
  
  def attempt_login(user_account)
    @logger.info "World: Processing login request for #{user_account.inspect}"
    # TODO: Would need to prevent dupes
    @avatars[user_account] = Avatar.new(user_account.username)
  end
  
  def notify_disconnect(user_account)
    @logger.info "World: Reacting to disconnction of #{user_account.inspect}"
    @avatars.delete(user_account)
  end
end