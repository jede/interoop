require 'interoop/abstract_actor'

class Interoop
  class Actor < AbstractActor
    attr_accessor :identifier, :known_addresses
    attr_accessor :communication_needs, :communication_mediums, :language_translations
    
    def initialize(params = {})
      super
      @identifier ||= Interoop::Address.new
      @identifier.actor = self if @identifier
      
      @known_addresses ||= []
      
      @communication_needs ||= []
      @communication_mediums ||= []
      @language_translations ||= []
    end
    
    def create_nodes_in(graph)
      super
      graph.add_edge(self, identifier)
      create_nodes_for_relations(graph, :communication_needs, :communication_mediums, :language_translations, :known_addresses)
    end
    
    def neighbors
      communication_mediums
    end
    
    def translates(options)
      LanguageTranslation.new(options.merge(:actor => self))
    end
    
    def sends(language)
      proxy = ChainProxy.new(self)
      proxy.sends(language)
      proxy
    end
    
    def needs_to_communicate_with(actor_or_actors)
      actors = actor_or_actors.is_a?(Array) ? actor_or_actors : [actor_or_actors]
      actors << self
      CommunicationNeed.new(:actors => actors)
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
    
  end
end