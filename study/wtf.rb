
require 'rubygems'
require 'bundler/setup'
require 'celluloid'

class MyActor
  include Celluloid
  
  def this_works
    ( (-1.0) ** 2 ) / ( 2.0 * 2 + 1.0 )
  end
  
  def this_does_not
    ( (-1.0) ** 3 ) / ( 2.0 * 3 + 1.0 )
  end
  
end

boss = MyActor.new
boss.this_works     and puts "Here1"
boss.this_does_not  and puts "Here2"

sleep 15
