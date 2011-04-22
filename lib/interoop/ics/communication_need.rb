class Interoop::Ics
  class CommunicationNeed < Object
    attr_accessor :subject, :actors, :reference_language, :addressing_needs
    
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
    
    def update_actors!
      subject.communication_needs << self
      actors.each {|actor| actor.communication_needs << self}
    end
  end
end