require 'interoop/actor'
require 'interoop/communication_need'
require 'interoop/message_passing_system'
require 'interoop/language'
require 'interoop/language_translation'
require 'interoop/reference_language'
require 'interoop/address'

class Interoop
  def initialize
    @actors = []
    yield self, binding if block_given?
  end
  
  def analyze(communication_need)
    
  end
  
  def visualize(*actors)
    actors.each do |actor|
      require 'graphviz'

       # Create a new graph
       g = GraphViz.new( :G, :type => :digraph )

       # Create two nodes
       hello = g.add_node( "Hello" )
       world = g.add_node( "World" )

       # Create an edge between the two nodes
       g.add_edge( hello, world )

       # Generate output image
       g.output( :png => "hello_world.png" )
       
       exec "open hello_world.png"
    end
  end
  
  def self.load(path)
    Interoop.new do |interoop, binding|
      File.open(path) do |f|
         eval f.readlines.join(' '), binding
      end
    end
  end
end