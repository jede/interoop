class Interoop::Ics
  class Object
    attr_accessor :name
    alias_method :to_s, :name
    
    def initialize(params = {})
      params.each_pair do |name, value|
        instance_variable_set("@#{name}".to_sym, value)
      end
    end
    
    protected
    
    def one_of(queue)
      none = all_of queue.map{|n| 1 - n}
      1 - none
    end
    
    def all_of(queue)
      return 1 if queue.empty?
      queue.shift * all_of(queue)
    end
    
    def max(a, b)
      a > b ? a : b
    end
    
  end
end