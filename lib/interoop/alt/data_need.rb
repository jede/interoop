class Interoop::Alt::DataNeed < Interoop::Alt::Need
  attr_accessor :data, :actor
  
  def create_nodes_in(graph)
    unless graph.has_node?(self)
      graph.add_edge(self, data) 
      super
    end
  end
  
  def path_available
    actor.path_available_to(data)
  end
  
  def path_exists
    actor.most_available_path_to(data).empty? ? 0.0 : 1.0
  end
  
  def message_delivers
    actor.message_delivers_to(data)
  end
    
  def syntactic_correct
    actor.syntactic_correct_to(data)
  end
    
  def semantic_correct
    actor.semantic_correct_to(data)
  end
  
end