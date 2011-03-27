class Interoop
  class AbstractActor
    attr_accessor :distorts_message, :drops_message, :is_available, :formats
    
    def initialize(params = {})
      @formats = params[:formats] || []
    end
    
    def reaches?(other, options = {})
      return true if other == self
      
      without_using = options[:without_using] || []
      without_using << self
      
      hit = neighbors.find do |neighbor|
        next if without_using.include?(neighbor)
        neighbor.reaches?(other, :without_using => without_using)
      end
      
      return !hit.nil?
    end
    
  end
end