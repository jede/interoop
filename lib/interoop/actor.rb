class Interoop
  class Actor
    attr_accessor :distorts_message, :drops_message, :is_available, :communication_needs
    
    def initialize(description)
      @communication_needs = []
    end
  end
end