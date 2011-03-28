require 'interoop/abstract_actor'

class Interoop
  class Actor < AbstractActor
    attr_accessor :identifier, :known_addresses
    attr_accessor :communication_needs, :communication_mediums, :language_translations
    
    def initialize(params = {})
      super
      @identifier = params[:identifier] || Interoop::Address.new()
      @identifier.actor = self if @identifier
      @known_addresses = params[:known_addresses] || []
      
      @communication_needs = params[:communication_needs] || []
      @communication_mediums = params[:communication_mediums] || []
      @language_translations = params[:language_translations] || []
    end
    
    def create_nodes_in(graph)
      super
      graph.add_edge(self, identifier)
      create_nodes_for_relations(graph, :communication_needs, :communication_mediums, :language_translations, :known_addresses)
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
    
    def neighbors
      communication_mediums
    end
  end
end