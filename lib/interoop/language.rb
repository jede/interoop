class Interoop
  class Language
    attr_accessor :name
    alias_method :to_s, :name
    
    def initialize(params = {})
      @name = params[:name]
    end
  end
end