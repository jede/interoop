class Interoop::Ics
  class Address < Interoop::Entity
    attr_accessor :actor
    
    def to_s
      "Unique address"
    end
  end
end