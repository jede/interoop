require 'interoop/abstract_actor'

class Interoop
  class Actor < AbstractActor
    attr_accessor :name, :identifier, :known_addresses
    attr_accessor :communication_needs, :communication_mediums, :language_translations
    
    def initialize(params = {})
      super
      @name = params[:name]
      @identifier = params[:identifier]
      @identifier.actor = self if @identifier
      @known_addresses = []
      
      @communication_needs = []
      @communication_mediums = []
      @language_translations = []
    end
    
    protected
    
    def neighbors
      communication_mediums
    end
    
  end
end