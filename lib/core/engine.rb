require_relative 'dao'
require_relative 'domain'

class Engine
  def start
    @dao = DAO.new
  end
  
  # Run through timed tasks and handle all their messages
  def execute_tasks
    #
  end
  
  # Run through client messages
  def execute_messages(user_accounts)
    user_accounts.each do |user_account|
      next if user_account.nil?
      user_account.from_client.each do |msg|
        puts "#{user_account.username} #{msg}"
      end
      user_account.from_client_clear
    end
  end
  
  def attempt_login(msg)
    # TODO: Verify that it is actually a login message
    # TODO: Parse JSON or something?
    UserAccount.new(msg)
  end
end