require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Interoop::MessagePassingSystem do
  before :each do
    @message_passing_system = new_message_passing_system
    @actor = @message_passing_system.actors.first
  end
  
  it "has actors" do
    @message_passing_system.actors.should be_an(Enumerable)
    @message_passing_system.actors.should_not be_empty
  end
  
  it "has a name" do
    @message_passing_system.name.should_not be_empty
  end
  
  it "can receive distorts_message, drops_message and is_available" do
    @message_passing_system.distorts_message = 0.5
    @message_passing_system.drops_message = 0.5
    @message_passing_system.is_available = 0.5
  end
  
  it "can be fixed" do
    @message_passing_system.fixed = true
  end
  
  it "has formats" do
    @message_passing_system.formats.should be_an(Enumerable)
  end
  
  it "has an addressing language" do
    @message_passing_system.addressing_language.should_not be_nil
  end
  
  it "can calculate if it reaches an actor" do
    @message_passing_system.reaches?(@actor).should eql(true)
    
    other_actor = new_actor
    @message_passing_system.reaches?(other_actor).should eql(false)
  end
  
  it "can calculate if it reaches another actor, without using some actor or message passing system" do
    other_actor = new_actor
    other_message_passing_system = new_message_passing_system(:actors => [other_actor, @actor])

    @message_passing_system.reaches?(other_actor).should eql(true)
    @message_passing_system.reaches?(other_actor, :without_using => [other_message_passing_system]).should eql(false)
  end
  
  describe "graph behaviour" do
     before :each do
       require 'graphviz'
       @graph = Interoop::Graph.new(:G)
       
       mock.proxy(@graph).add_node(@message_passing_system).any_times
       
       mock.proxy(@graph).add_node(@message_passing_system.addressing_language)
       mock.proxy(@graph).add_edge(@message_passing_system, @message_passing_system.addressing_language)
       
       @message_passing_system.formats.each do |lang|
         mock.proxy(@graph).add_node(lang)
         mock.proxy(@graph).add_edge(@message_passing_system, lang)
       end
     end

     it "creates nodes in a graph" do
       @message_passing_system.create_nodes_in(@graph)
     end
     
     it "only adds itself once" do
       @message_passing_system.create_nodes_in(@graph)
       @message_passing_system.create_nodes_in(@graph)
     end
   end
end