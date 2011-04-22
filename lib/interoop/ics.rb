require 'interoop/ics/object'
require 'interoop/ics/chain_proxy'
require 'interoop/ics/actor'
require 'interoop/ics/communication_need'
require 'interoop/ics/message_passing_system'
require 'interoop/ics/language'
require 'interoop/ics/language_translation'
require 'interoop/ics/reference_language'
require 'interoop/ics/address'
require 'interoop/ics/graph'

class Interoop::Ics
    attr_reader :name

    def initialize(name)
      @name = name
      @visualize_actors = []
      yield self, binding if block_given?
    end

    def visualize(*actors)
      @visualize_actors += actors if actors.is_a?(Array)
    end

    def visualize!
      graph = generate_graph(@visualize_actors)

      graph.output( :pdf => "#{name}.pdf" )
      graph.output( :dot => "#{name}.dot" )

      exec "open #{name}.pdf"
    end

    def generate_graph(actors)
      require 'graphviz'
      graph = Graph.new( :G, :type => :graph, :use => "neato" )
      graph[:overlap] = false
      graph[:rankdir] = "LR"

      actors.each do |actor|
        actor.create_nodes_in(graph)
      end

      return graph
    end
end