require_relative 'dao'
require_relative 'domain'

class Engine
  
  def start
    @dao = DAO.new
  end
  
  def advance(user_accounts)
    # TODO: Run through timed tasks and handle all their messages
    user_accounts.each do |user_account|
      unless user_account.nil?
        puts "Test: #{user_account.inspect}"
      end
    end
  end
  
  def attempt_login(msg)
    # TODO: Verify that it is actually a login message
    # TODO: Parse JSON or something?
    UserAccount.new(msg)
  end
end