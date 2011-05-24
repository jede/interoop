class Interoop::Alt::Transformation < Interoop::Entity
  attr_accessor :from, :to, :correct
  
  def initialize(params = {})
    super
    
    @correct ||= 1.0
  end
  
  def attributes
    {correct: correct}
  end
  
end