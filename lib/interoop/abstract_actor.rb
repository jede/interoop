class Interoop
  class AbstractActor < Object
    attr_accessor :distorts_message, :drops_message, :is_available, :formats
    
    def initialize(params = {})
      super
      @formats ||= []
      @distorts_message ||= 0.0
      @drops_message ||= 0.0
      @is_available ||= 1.0
    end
    
    def add_format(language)
      self.formats << language unless formats.include?(language)
    end
    
    def reaches(other, options = {})
      return 1.0 if other == self
      
      without_using = options[:without_using] || []
      without_using << self
      
      hit = neighbors.find do |neighbor|
        next if without_using.include?(neighbor)
        neighbor.reaches(other, :without_using => without_using) == 1.0
      end
      
      return (hit.nil? ? 0.0 : 1.0)
    end
    
    def attributes
      {
        :distorts_message => distorts_message, 
        :drops_message => drops_message, 
        :is_available => is_available
      }
    end
    
    def create_nodes_in(graph)
      graph.add_node(self)
      
      formats.each do |language|
        graph.add_edge(self, language)
      end
    end
  end
end