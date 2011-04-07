class Interoop::ChainProxy
  attr_accessor :language, :message_passing_system, :start_actor, :end_actor
  
  def initialize(actor)
    @start_actor = actor
  end
  
  def sends(language)
    @language = language
    start_actor.add_format(language)
    self
  end
  
  def through(message_passing_system)
    @message_passing_system = message_passing_system
    message_passing_system.add_format(language)
    message_passing_system.add_actor(start_actor)
    self
  end
  
  def to(actor)
    @end_actor = actor
    end_actor.add_format(language)
    message_passing_system.add_actor(end_actor)
    self
  end
end