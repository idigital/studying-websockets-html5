require_relative 'dao'
require_relative 'domain'

class Engine
  
  def start
    @dao = DAO.new
  end
  
  def advance
    # TODO: Run through the client_q and handle all the messages
  end
  
  def attempt_login(msg)
    # TODO: Verify that it is actually a login message
    UserAccount.new(msg)
  end
end