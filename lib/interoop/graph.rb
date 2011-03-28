require 'graphviz'

class Interoop
  class Graph < GraphViz
    attr_accessor :node_map
    
    def initialize(*args)
      super
      @node_map = {}
    end
    
    def add_node(interoop_node, options = {})
      return nil if interoop_node.nil?
      return @node_map[interoop_node] if has_node?(interoop_node)
      
      /(\w+::)?(?<interoop_class>\w+)/ =~ interoop_node.class.to_s
      options[:shape] = :record
      options[:label] = "[[#{interoop_class}]]\n#{interoop_node.to_s}" 
      
      if interoop_node.respond_to?(:attributes)
        interoop_node.attributes.each_pair do |key, value|
          options[:label] += " | #{key}: #{value}"
        end
      else
        options[:label] += " | "
      end
      
      @node_map[interoop_node] = super(interoop_node.object_id.to_s, options)
    end
    
    def has_node?(interoop_node)
      @node_map.include?(interoop_node)
    end
    
    def add_edge(first, second)
      super(add_node(first), add_node(second))
    end
  end
end