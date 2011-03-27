class Interoop
  class Language
    attr_accessor :name, :formats
    
    def initialize(params = {})
      @name = params[:name]
      @formats = []
    end
  end
end