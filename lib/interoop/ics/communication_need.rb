class Interoop::Ics
  class CommunicationNeed < Interoop::Entity
    attr_accessor :id, :subject, :actors, :reference_language, :addressing_needs
    
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
      self.id = self.class.generate_id(name)
    end
    
    def update(options)
      self.actors += options[:actors]
      update_actors!
      self
    end
    
    def self.find_or_build(options)
      if id = options[:id] || generate_id(options[:name])
        @instances ||= {}
        if @instances[id] 
          @instances[id].update(options)
        else
          @instances[id] = self.new(options)
        end
      else
        self.new(options)
      end
    end
    
    def satisfied
      all_of [
        path_exists,
        path_available,
        (1 - drops_message),
        (1 - syntactic_distortion),
        semantically_correct,
        language_success
      ]
    end
    
    def path_exists
      actors.reduce(0.0) do |memo, actor|
        max(memo, subject.reaches(actor))
      end
    end
    
    def path_available
      all_of actors.map{|a| subject.path_is_available_to(a)}
    end
    
    def drops_message
      one_of actors.map { |a| subject.drops_message_to(a) }
    end
    
    def syntactic_distortion
      one_of actors.map { |a| subject.distorts_message_to(a) }
    end
    
    def language_success
      one_of [language_chain_exists, common_language_exists]
    end
    
    def common_language_exists
      all_of actors.map{|a| subject.common_languages_with(a).empty? ? 0.0 : 1.0}
    end
    
    def language_chain_exists
      all_of actors.map{|a| subject.common_languages_by_chain_with(a).empty? ? 0.0 : 1.0}
    end
    
    def semantically_correct
      all_of actors.map { |a| subject.semantically_correct_message_to(a) }
    end
    
    def attributes
      {
        satisfied: satisfied,
        path_exists: path_exists,
        path_available: path_available,
        drops_message: drops_message,
        syntactic_distortion: syntactic_distortion,
        common_language_exists: common_language_exists,
        language_chain_exists: language_chain_exists,
        semantically_correct: semantically_correct
      }
    end
    
    def create_nodes_in(graph)
      graph.add_edge(self, reference_language) if reference_language
    end
    
    protected
    
    def self.generate_id(name)
      name.downcase.gsub(/[^a-z0-9]+/,'_').to_sym unless name.nil? || name.empty?
    end
    
    def update_actors!
      subject.communication_needs << self  unless subject.communication_needs.include?(self)
      actors.each {|actor| actor.communication_needs << self unless actor.communication_needs.include?(self)}
    end
  end
end