require 'interoop/abstract_actor'

class Interoop
  class MessagePassingSystem < AbstractActor
    attr_accessor :fixed
    attr_accessor :actors, :addressing_language
    
    def initialize(params = {})
      super
      @addressing_language = params[:addressing_language]
      @actors = params[:actors] || []
      update_actors!
    end
    
    protected
    
    def neighbors
      actors
    end
    
    def update_actors!
      actors.each {|actor| actor.communication_mediums << self}
    end
  end
end
