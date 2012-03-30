
require 'rubygems'
require 'bundler/setup'

require 'celluloid'

class Worker
  include Celluloid
  
  def do_it(sender, n)
    sender.result_msg! n * 2
  end
end

class Boss
  include Celluloid
  
  def do_it(numbers)
    numbers.each do |n|
      worker = Worker.new
      worker.do_it! current_actor, n
      puts "Hi! #{n}"
    end
  end
  
  def result_msg(amt)
    puts "Amount: #{amt}"
  end
end

boss = Boss.new
boss.do_it! [1,2,3,4,5]
sleep 10
