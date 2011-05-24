require 'interoop/alt/actor'

class Interoop::Alt
  class RelayActor < Actor
    attr_accessor :fixed
    
    def initialize(params = {})
      super
      
      @fixed = false unless @fixed
    end
    
    def create_nodes_in(graph)
      unless graph.has_node?(self)
        super
      end
    end
    
    def attributes
      super.merge(:fixed => fixed)
    end
    
  end
end
