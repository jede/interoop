class Interoop
  class CommunicationNeed < Object
    attr_accessor :actors, :reference_language, :addressing_needs
    
    def to_s
      unless name
        if actors.count < 3
          self.name = actors.join(',')
        else
          self.name = "#{actors.count} actors"
        end
      end
      name
    end
    
    def initialize(params = {})
      super
      @addressing_needs ||= []
      update_actors!
    end
    
    def path_exists
      reference_actor = actors.first
      actors.reject{|a| a == reference_actor}.reduce(0.0) do |memo, actor|
        max(memo, reference_actor.reaches(actor))
      end
    end
    
    def path_available
      start_actor = actors.first

      available = {}
      available[start_actor] = start_actor.is_available
      actors_que = [start_actor]
      visited = []
      
      while actor = actors_que.pop
        visited << actor
        
        actor.neighbors.each do |neighbor|
          actors_que << neighbor unless visited.include?(neighbor)
          available[neighbor] = max(available[neighbor].to_f, available[actor] * neighbor.is_available)
        end
        
        actors_que.sort_by!{|a| a.is_available}.reverse!
      end
      
      other_actors = actors.reject{|a| a == start_actor}
      least_available_actor = other_actors.min {|actor| available[actor] }
      
      return available[least_available_actor]
    end
    
    def common_language_exists
      
    end
    
    def attributes
      {
        :path_exists => path_exists,
        :path_available => path_available
      }
    end
    
    def create_nodes_in(graph)
      graph.add_edge(self, reference_language) if reference_language
    end
    
    protected
    
    def max(a, b)
      a > b ? a : b
    end
    
    def update_actors!
      actors.each {|actor| actor.communication_needs << self}
    end
  end
end