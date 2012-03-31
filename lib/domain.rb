
class UserAccount
  attr_reader :username
  attr_accessor :from_client
  attr_accessor :to_client
  
  def initialize(username)
    @username = username
    @from_client = []
    @to_client = []
    
    puts "Test: #{username} created"
  end
end