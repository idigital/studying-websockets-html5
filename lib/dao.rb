require 'sequel'
require 'celluloid'

class DAO
  include Celluloid
  
  DB = Sequel.sqlite
  
  def initialize
    wipe
  end
  
  def start
    #
  end
  
  private
  
  def wipe
    begin
      DB.drop_table(:cells)
    rescue
    end
    
    DB.create_table(:cells) do
      primary_key :id
      Integer :x
      Integer :y
    end
  end
end
