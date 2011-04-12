class Interoop
  class LanguageTranslation < Object
    attr_accessor :to, :from, :actor, :correct
    
    def to_s
      "#{from} to #{to}"
    end
    
    def initialize(params = {})
      super
      @actor.language_translations << self if @actor
    end
    
    def create_nodes_in(graph)
      graph.add_edge(self, @to)
      graph.add_edge(self, @from)
    end
    
    def translates_to(language)
      if language == from
        to
      elsif language == to
        from
      end
    end
    
  end
end