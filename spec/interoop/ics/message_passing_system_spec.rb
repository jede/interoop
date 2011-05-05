require File.expand_path(File.dirname(__FILE__) + '/../../ics_spec_helper')

describe Interoop::Ics::MessagePassingSystem do
  before :each do
    @message_passing_system = new_message_passing_system
    @actor = @message_passing_system.actors.first
  end
  
  it "has actors" do
    @message_passing_system.actors.should be_an(Enumerable)
    @message_passing_system.actors.should_not be_empty
  end
  
  it "can add an actor" do
    other_actor = new_actor
    @message_passing_system.add_actor(other_actor)
    @message_passing_system.actors.should include(@actor)
    other_actor.communication_mediums.should include(@message_passing_system)
  end
  
  it "only is added once on an actor" do
    actors = @message_passing_system.actors
    @message_passing_system.add_actor(@actor)
    @message_passing_system.actors.should eql(actors)
  end
  
  it "has a name" do
    @message_passing_system.name.should_not be_empty
  end
  
  it "can receive distorts_message, drops_message and is_available" do
    @message_passing_system.distorts_message = 0.5
    @message_passing_system.drops_message = 0.5
    @message_passing_system.is_available = 0.5
  end
  
  it "sets distorts_message, drops_message and is_available to default values" do
    other_message_passing_system = Interoop::Ics::MessagePassingSystem.new
    other_message_passing_system.distorts_message.should == 0.0
    other_message_passing_system.drops_message.should == 0.0
    other_message_passing_system.is_available.should == 1.0
  end
  
  it "can be fixed" do
    @message_passing_system.fixed = true
  end
  
  it "is not fixed by default" do
    Interoop::Ics::MessagePassingSystem.new.fixed.should == false
  end
  
  it "has formats" do
    @message_passing_system.formats.should be_an(Enumerable)
  end
  
  it "adds formats only once" do
    lang = new_language    
    count = @message_passing_system.formats.count
    
    @message_passing_system.add_format(lang)
    @message_passing_system.add_format(lang)
    
    @message_passing_system.formats.count.should eql(count + 1)
  end
  
  it "has an addressing language" do
    @message_passing_system.addressing_language.should_not be_nil
  end
  
  it "can calculate the probability that it reaches an actor" do
    @message_passing_system.reaches(@actor).should eql(1.0)
    
    other_actor = new_actor
    @message_passing_system.reaches(other_actor).should eql(0.0)
  end
  
  it "can calculate the probability that it reaches another actor, without using some actor or message passing system" do
    other_actor = new_actor
    other_message_passing_system = new_message_passing_system(:actors => [other_actor, @actor])

    @message_passing_system.reaches(other_actor).should eql(1.0)
    @message_passing_system.reaches(other_actor, :without_using => [other_message_passing_system]).should eql(0.0)
  end
  
  describe "graph behaviour" do
     before :each do
       require 'graphviz'
       @graph = Interoop::Ics::Graph.new(:G)
       
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