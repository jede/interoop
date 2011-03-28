require 'interoop/actor'
require 'interoop/communication_need'
require 'interoop/message_passing_system'
require 'interoop/language'
require 'interoop/language_translation'
require 'interoop/reference_language'
require 'interoop/address'
require 'interoop/graph'

class Interoop
  attr_reader :name
  
  def initialize(name)
    @name = name
    yield self, binding if block_given?
  end
  
  def visualize(*actors)
    graph = generate_graph(actors)
    
    graph.output( :pdf => "#{name}.pdf" )    
    graph.output( :dot => "#{name}.dot" )    
    
    exec "open #{name}.pdf"
  end
  
  def self.load(path)
    /(.*\/)?(?<name>\w+).rb/ =~ path # path = "workbench/test.rb" => name = "test"
    Interoop.new(name) do |interoop, binding|
      File.open(path) do |f|
         eval f.readlines.join(' '), binding
      end
    end
  end
  
  def generate_graph(actors)
    require 'graphviz'
    graph = Interoop::Graph.new( :G, :type => :graph, :use => "neato" )
    graph[:overlap] = false
    graph[:rankdir] = "LR"
    
    actors.each do |actor|
      actor.create_nodes_in(graph)
    end
    
    return graph
  end
end