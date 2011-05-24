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
      
      /(\w+::)?(?<interoop_class>\w+)$/ =~ interoop_node.class.to_s
      options[:shape] = :record
      options[:label] = "[[#{interoop_class}]]\n#{interoop_node.to_s}" 
      
      if interoop_node.respond_to?(:attributes)
        options[:label] += compile_label(interoop_node.attributes)
      else
        options[:label] += " | "
      end
      
      @node_map[interoop_node] = super(interoop_node.object_id.to_s, options)
    end
    
    def compile_label(attributes)
      label = ""
      attributes.each_pair do |key, value|
        label += " | #{key}: #{value}"
      end
      label
    end
    
    
    def has_node?(interoop_node)
      @node_map.include?(interoop_node)
    end
    
    def add_edge(first, second)
      super(add_node(first), add_node(second))
    end
  end
end