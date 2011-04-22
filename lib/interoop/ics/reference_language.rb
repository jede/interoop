class Interoop::Ics
  class ReferenceLanguage < Language
    attr_accessor :communication_needs
    
    def initialize(params = {})
      super
      @communication_needs ||= []
    end
  end
end