class Interoop
  class Visualizer
    attr_reader :name
    
    def initialize(name)
      @name = name
      @visualize_actors = []
    end
    
    def visualize(*actors)
      @visualize_actors += actors if actors.is_a?(Array)
    end
    
    def visualize!
      graph = generate_graph(@visualize_actors)
    
      graph.output( :pdf => "#{name}.pdf" )
      graph.output( :dot => "#{name}.dot" )
    
      exec "open #{name}.pdf"
    end
    
    def generate_graph(actors)
      require 'graphviz'
      graph = Interoop::Graph.new( :G, :type => :graph, :use => "neato" )
      graph[:overlap] = false
      graph[:rankdir] = "LR"
    
      actors.each do |actor|
        actor.create_nodes_in(graph)
      end
    
      return graph
    end
  end
end