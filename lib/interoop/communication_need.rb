class Interoop
  class CommunicationNeed
    attr_accessor :actors, :reference_language, :addressing_needs
    
    def to_s
      actors.join(' ')
    end
    
    def initialize(params = {})
      @actors = params[:actors]
      @reference_language = params[:reference_language]
      @addressing_needs = []
      update_actors!
    end
    
    def path_exists?
      reference_actor = actors.first
      actors.reduce(true) do |memo, actor|
        memo && reference_actor.reaches?(actor)
      end
    end
    
    def attributes
      {
        :path_exists => path_exists?
      }
    end
    
    def create_nodes_in(graph)
      graph.add_edge(self, reference_language) if reference_language
    end
    
    protected
    
    def update_actors!
      actors.each {|actor| actor.communication_needs << self}
    end
  end
end