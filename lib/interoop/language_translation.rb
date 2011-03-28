class Interoop
  class LanguageTranslation
    attr_accessor :to, :from, :actor
    
    def to_s
      "#{from} to #{to}"
    end
    
    def initialize(params = {})
      @actor = params[:actor]
      @actor.language_translations << self if @actor
      @to = params[:to]
      @from = params[:from]
    end
    
    def create_nodes_in(graph)
      graph.add_edge(self, @to)
      graph.add_edge(self, @from)
    end
  end
end