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
    
    def most_available_path_to(other_actor)
      available = {self => is_available}
      actors_que = [self]
      visited_map = {self => nil}
      
      while actor = actors_que.pop
        actor.neighbors.each do |neighbor|
          actors_que << neighbor unless visited_map.keys.include?(neighbor)
          
          current_value = available[neighbor].to_f
          possible_better_value = available[actor] * neighbor.is_available
          
          if possible_better_value > current_value
            available[neighbor] = possible_better_value
            visited_map[neighbor] = actor
          end
        end
        
        actors_que.sort_by!{|a| a.is_available}.reverse!
      end
      
      path = [other_actor]
      while prev = visited_map[path.first]
        path.unshift(prev)
      end
      path = [] unless path.first == self && path.last == other_actor
      
      return path
    end
    
    def common_languages_with(actor)
      most_available_path_to(actor).reduce(formats) do |languages, abstract_actor|
        languages & abstract_actor.formats
      end
    end
    
    def common_languages_by_chain_with(actor)
      most_available_path_to(actor).reduce(formats) do |languages, abstract_actor|
        languages_by_translations = abstract_actor.is_a?(Actor) ? abstract_actor.languages_through_translations_of(languages) : []
        (languages & abstract_actor.formats) + languages_by_translations
      end
    end
    
    def languages_through_translations_of(languages)
      language_translations.reduce([]) do |all_translated_into, translation|
        all_translated_into + languages.map { |language| translation.translates_to(language) }.reject(&:nil?)
      end
    end
    
    def semantically_correct_message_to(actor)
      path = most_available_path_to(actor)
      start = path.shift
      formats.reduce(0.0) do |highest, language|
        max(find_highest_correctness(path, language), highest)
      end
    end
    
    def path_is_available_to(actor)
      all_of most_available_path_to(actor).map(&:is_available)
    end
    
    def drops_message_to(actor)
      one_of most_available_path_to(actor).map(&:drops_message)
    end
    
    def distorts_message_to(actor)
      one_of most_available_path_to(actor).map(&:distorts_message)
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
      CommunicationNeed.new(:subject => self, :actors => actors)
    end
    
    def knows_address_to(actor)
      self.known_addresses << actor.identifier unless known_addresses.include?(actor.identifier)
    end
    
    protected
    
    def find_highest_correctness(path, language)
      return 1.0 unless abstract_actor = path.shift
      
      highest = abstract_actor.formats.include?(language) ? find_highest_correctness(path, language) : 0.0
      
      if abstract_actor.is_a?(Actor)
        abstract_actor.language_translations.each do |translation|
          translates_to = translation.translates_to(language)
          highest = max(translation.correct * find_highest_correctness(path, translates_to), highest) if translates_to
        end
      end
      
      return highest
    end
    
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