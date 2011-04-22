require 'interoop/ics/abstract_actor'

class Interoop::Ics
  class MessagePassingSystem < AbstractActor
    attr_accessor :fixed
    attr_accessor :actors, :addressing_language
    
    def initialize(params = {})
      super
      
      @fixed = false unless @fixed
      @actors ||= []
      
      update_actors!
    end
    
    def create_nodes_in(graph)
      unless graph.has_node?(self)
        super
        graph.add_edge(self, addressing_language) unless fixed || addressing_language.nil?
      end
    end
    
    def attributes
      super.merge(:fixed => fixed)
    end
    
    def neighbors
      actors
    end
    
    def add_actor(actor)
      self.actors << actor
      update_actors!
    end

    protected
    
    def update_actors!
      actors.each {|actor| actor.communication_mediums << self unless actor.communication_mediums.include?(self)}
    end
  end
end
