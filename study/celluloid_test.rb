require 'rubygems'
require 'bundler/setup'

require 'celluloid'

class Sheen
  include Celluloid
  
  def initialize(name)
    @name = name
  end
  
  def set_status(status)
    @status = status
  end
  
  def report
    "#{@name} is #{@status}"
  end
  
end

class PorscheSpider
  include Celluloid
  
  class CarInMyLaneError < StandardError; end
  
  def drive_on_route_466
    raise CarInMyLaneError, "head on collision :("
  end
end

class JamesDean
  include Celluloid
  
  def initialize
    @little_bastard = PorscheSpider.new_link
  end
  
  def drive_little_bastard
    @little_bastard.drive_on_route_466
  end
  
end

class ElizabethTaylor
  include Celluloid
  
  #trap_exit :actor_died
  
  #def actor_died(actor, reason)
  #  p "Oh no! #{actor.inspect} has died because of a #{reason.class}"
  #end
  
end

class TimerExample
  include Celluloid
  attr_reader :fired, :timer
  
  def initialize
    @fired = false
    @timer = after(3) { puts "Timer fired!"; @fired = true }
  end
  
end

class ResetExample
  include Celluloid
  
  INACTIVITY_TIMEOUT = 10
  
  def initialize
    @timer = after(INACTIVITY_TIMEOUT) { terminate }
  end
  
  # Any method that does something and suspense the inactivity timeout
  def activity
    @timer.reset
  end
end

class MyMessage
  attr_reader :text
  
  def initialize(text)
    @text = text
  end
end

class MyActor
  include Celluloid
  
  def initialize
    wait_for_my_messages!
  end
  
  def wait_for_my_messages
    loop do
      message = receive { |msg| msg.is_a? MyMessage }
      puts "Got a MyMessage: #{message.inspect}"
    end
  end
  
end
