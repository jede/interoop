require 'interoop/actor'

class Interoop
  def initialize
    @actors = []
  end
  
  def add(object)
    @actors << object
  end
  
  def actor_count
    @actors.count
  end
end