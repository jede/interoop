class Interoop::Alt
  class Actor < Interoop::Entity
    attr_accessor :correct, :delivers, :available
    
    attr_writer :exchanges
    
    def initialize(params = {})
      super
      @formats ||= []
      @correct ||= 1.0
      @delivers ||= 1.0
      @available ||= 1.0

      @exchanges ||= []
    end
    
    def transformations(*args)
      []
    end
    
    def exchanges(options = {})
      case options[:as] 
      when :sender
        @exchanges.find_all{|e| e.from == self}
      when :receiver
        @exchanges.find_all{|e| e.to == self}
      else
        @exchanges
      end
    end
    
    def neighbors_sending(data)
      exchanges(:as => :receiver).find_all do |exchange|
        exchange.data == data
      end.map(&:from)
    end
    
    def path_available_to(data)
      all_of actors_in(most_available_path_to(data)).map(&:available)
    end
    
    def message_delivers_to(data)
      all_of actors_in(most_available_path_to(data)).map(&:delivers)
    end
    
    def syntactic_correct_to(data)
      all_of actors_in(most_available_path_to(data)).map(&:correct)
    end
    
    def semantic_correct_to(data)
      all_of most_available_path_to(data).find_all{|n| n.is_a?(Transformation)}.map(&:correct)
    end
    
    def most_available_path_to(data)
      ways = data.ways_to(self)
      return [] if ways.empty?
      ways.max_by do |way|
        all_of actors_in(way).map(&:available)
      end
    end
    
    def ways_to(actor, data, visited = [])
      ways = []
      return [ways] if self == actor
      
      exchanges(:as => :sender).each do |exchange|
        next if visited.include?(exchange)
        ways += exchange.to.ways_to(actor, data, visited.push(exchange)).map{|w| [exchange] + w } if data == exchange.data
        
        transformations(from: data).each do |transformation|
          next if visited.include?(transformation)
          ways += exchange.to.ways_to(actor, transformation.to, visited.push(transformation)).map{|w| [transformation, exchange] + w } if transformation.to == exchange.data
        end
      end
      
      ways
    end
    
    def attributes
      {
        correct: correct, 
        delivers: delivers, 
        available: available
      }
    end
    
    def create_nodes_in(graph)
      graph.add_node(self)
      create_nodes_for_relations(graph, :exchanges)
    end
    
    protected
    
    def create_nodes_for_relations(graph, *relations)
      relations.each do |relation|
        send(relation).each do |object|
          object.create_nodes_in(graph) if object.respond_to?(:create_nodes_in)
          graph.add_edge(self, object)
        end
      end
    end
    
    def actors_in(way)
      way.reduce([]) do |memo, node| 
        if node.is_a?(Exchange)
          memo << node.from if memo.empty?
          memo << node.to
        end
        memo
      end
    end
    
  end
end