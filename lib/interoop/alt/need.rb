class Interoop::Alt::Need < Interoop::Entity
  attr_accessor :communication_needs
  
  def initialize(*args)
    @communication_needs = []
    super
  end

  def create_nodes_in(graph)
    communication_needs.each do |communication_need|
      communication_need.create_nodes_in(graph)
      graph.add_edge(communication_need, self) 
    end
  end
  
  def attributes
    @attributes ||= {
      satisfied: satisfied,
      path_available: path_available,
      path_exists: path_exists,
      message_delivers: message_delivers,
      syntactic_correct: syntactic_correct,
      semantic_correct: semantic_correct
    }
  end
  
  def satisfied
    all_of [
      path_available,
      path_exists,
      message_delivers,
      syntactic_correct,
      semantic_correct
    ]
  end  
end