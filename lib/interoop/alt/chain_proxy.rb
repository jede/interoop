class Interoop::Alt
  class ChainProxy
    attr_accessor :data, :middle_actor, :start_actor, :end_actor
    
    def initialize(actor)
      @start_actor = actor
    end
    
    def sends(data)
      data.creator ||= @start_actor
      @data = data
      self
    end
    
    def through(middle_actor)
      @middle_actor = middle_actor
      Exchange.new(from: start_actor, to: middle_actor, data: data)
      self
    end
    
    def to(end_actor)
      @end_actor = end_actor
      Exchange.new(from: middle_actor, to: end_actor, data: data)
      self
    end
  end
end