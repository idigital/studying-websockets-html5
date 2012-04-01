require_relative 'domain'
require_relative '../impl/world'

class Engine
  def start
    @world = World.new
  end
  
  # Run through timed tasks and handle all their messages
  def execute_tasks
    @world.advance
  end
  
  # Run through client messages
  def execute_messages(user_accounts)
    user_accounts.each do |user_account|
      next if user_account.nil?
      user_account.from_client.each do |msg|
        @world.execute(user_account, msg)
      end
      user_account.from_client_clear
    end
  end
  
  def attempt_login(msg)
    # TODO: Verify that it is actually a login message
    user_account = UserAccount.new(msg)
    @world.attempt_login(user_account)
    # TODO: Verify successful authentication, prolly return nil and/or false on failure
    return user_account
  end
  
  def notify_disconnect(user_account)
    @world.notify_disconnect(user_account)
  end
end