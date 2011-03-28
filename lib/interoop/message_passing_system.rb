require 'interoop/abstract_actor'

class Interoop
  class MessagePassingSystem < AbstractActor
    attr_accessor :fixed
    attr_accessor :actors, :addressing_language
    
    def initialize(params = {})
      super
      @addressing_language = params[:addressing_language]
      @actors = params[:actors] || []
      update_actors!
    end
    
    def create_nodes_in(graph)
      unless graph.has_node?(self)
        super
        graph.add_edge(self, addressing_language) unless fixed || addressing_language.nil?
      end
    end
    
    protected
    
    def neighbors
      actors
    end
    
    def update_actors!
      actors.each {|actor| actor.communication_mediums << self}
    end
  end
end
