class Interoop
  class AbstractActor
    attr_accessor :distorts_message, :drops_message, :is_available, :formats, :name
    alias_method :to_s, :name
    
    def initialize(params = {})
      @name = params[:name]
      @formats = params[:formats] || []
      @distorts_message = params[:distorts_message].to_f
      @drops_message = params[:drops_message].to_f
      @is_available = params[:is_available].to_f
    end
    
    def reaches?(other, options = {})
      return true if other == self
      
      without_using = options[:without_using] || []
      without_using << self
      
      hit = neighbors.find do |neighbor|
        next if without_using.include?(neighbor)
        neighbor.reaches?(other, :without_using => without_using)
      end
      
      return !hit.nil?
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