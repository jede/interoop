class Interoop::Alt::Data < Interoop::Entity
  #attr_accessor :created_by, :transformed_to_by, :transformed_from_by, :sent_by, :data_needs
  attr_accessor :creator
  
  def ways_to(actor)
    creator.ways_to(actor, self)
  end
  
end