class Interoop
  class Address
    attr_accessor :actor
    
    def initialize(params = {})
      @actor = params[:actor]
    end
  end
end