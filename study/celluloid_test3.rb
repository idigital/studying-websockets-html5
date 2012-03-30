
require 'rubygems'
require 'bundler/setup'

require 'celluloid'

class Worker
  include Celluloid
  
  def cheeseburger(x)
    puts "Start #{x}"
    (1..10000000).reduce { |x,y| x+y }
    sleep 1
    puts "End #{x}"
  end
end

worker = Worker.new
(1..50).each do |x|
  puts "Before #{x}"
  worker = Worker.new
  worker.cheeseburger! x
  puts "After #{x}"
end

sleep 20
