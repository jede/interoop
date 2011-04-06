class Interoop
  class Object
    attr_accessor :name
    alias_method :to_s, :name
    
    def initialize(params = {})
      params.each_pair do |name, value|
        instance_variable_set("@#{name}".to_sym, value)
      end
    end
  end
end