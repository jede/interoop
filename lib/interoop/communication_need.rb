class Interoop
  class CommunicationNeed
    attr_accessor :actors, :reference_language, :addressing_needs
    
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
    
    protected
    
    def update_actors!
      actors.each {|actor| actor.communication_needs << self}
    end
  end
end