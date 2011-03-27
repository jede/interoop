class Interoop
  class LanguageTranslation
    attr_accessor :actor, :first_language, :second_language
    
    def initialize(params = {})
      @actor = params[:actor]
      @first_language = params[:first_language]
      @second_language = params[:second_language]
    end
  end
end