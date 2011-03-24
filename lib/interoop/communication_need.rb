class CommunicationNeed
  def initialize(first, second)
    @first = first
    @second = second
  end
  
  def self.between(first, second)
    communication_need = CommunicationNeed.new(first, second)
    first.communication_needs << communication_need
    second.communication_needs << communication_need
  end
end