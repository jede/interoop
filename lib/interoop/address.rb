class Interoop
  class Address
    attr_accessor :actor
    
    def initialize(params = {})
      @actor = params[:actor]
    end
    
    def to_s
      "Unique address"
    end
  end
end