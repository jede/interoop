class Interoop::Alt::CommunicationNeed < Interoop::Alt::Need
  attr_accessor :needs
  
  def initialize(*args)
    @needs = []
    super
  end
  
  def self.find_or_create_by_group(group)
    @communication_needs ||= {}
    @communication_needs[group] ||= new(name: group)
  end
  
  def add_need(need)
    unless needs.include?(need)
      need.communication_needs << self 
      self.needs << need
    end
  end
  
  def method_missing(name, *args)
    if [:path_available,
        :path_exists,
        :message_delivers,
        :syntactic_correct,
        :semantic_correct
      ].include?(name)
      return all_of needs.map(&name.to_sym)
    else
      super.send name, *args
    end
  end
end