class Interoop::Alt::Exchange < Interoop::Entity
  attr_accessor :data, :from, :to
  
  def initialize(*args)
    super
    update_actors!
  end
  
  def create_nodes_in(graph)
    graph.add_edge(self, data) unless graph.has_node?(self)
  end
  
  protected
  
  def update_actors!
    to.exchanges << self unless to.exchanges.include?(self)
    from.exchanges << self unless from.exchanges.include?(self)
  end
end