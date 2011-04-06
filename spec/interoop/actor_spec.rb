require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Interoop::Actor do
  before :each do
    @actor = new_actor
  end
  
  it "can receive distorts_message, drops_message and is_available" do
    @actor.distorts_message = 0.5
    @actor.drops_message = 0.5
    @actor.is_available = 0.5
  end
  
  it "sets distorts_message, drops_message and is_available to default values" do
    other_actor = Interoop::Actor.new
    other_actor.distorts_message.should == 0.0
    other_actor.drops_message.should == 0.0
    other_actor.is_available.should == 1.0
  end
  
  it "can have communication needs" do
    @actor.communication_needs.should be_an(Enumerable)
  end
  
  it "has communication mediums" do
    @actor.communication_mediums.should be_an(Enumerable)
  end
  
  it "has formats" do
    @actor.formats.should be_an(Enumerable)
    @actor.formats.should_not be_empty
  end
  
  it "has language translations" do
    @actor.language_translations.should be_an(Enumerable)
  end
  
  it "has an identifier" do
    @actor.identifier.should_not be_nil
  end
  
  it "sets itself as actor on the given identifier" do
    @actor.identifier.actor.should eql(@actor)
  end
  
  it "has known addresses" do
    @actor.known_addresses.should be_an(Enumerable)
  end
  
  it "can calculate the propability that it reaches another actor" do
    other_actor = new_actor(:name => "Other actor")
    @actor.reaches(other_actor).should eql(0.0)
    message_passing_system = new_message_passing_system(:actors => [other_actor, @actor])
    @actor.reaches(other_actor).should eql(1.0)
  end
  
  it "can calculate the propability that it reaches another actor, without using some actor or message passing system" do
    other_actor = new_actor
    message_passing_system = new_message_passing_system(:actors => [other_actor, @actor])

    @actor.reaches(other_actor).should eql(1.0)
    @actor.reaches(other_actor, :without_using => [message_passing_system]).should eql(0.0)
  end
  

  describe "graphing" do
    before :each do
      @graph = Interoop::Graph.new(:G)
    end
    
    describe "with mock" do
      before :each do
        
        mock.proxy(@graph).add_node(@actor).any_times
        
        mock.proxy(@graph).add_node(@actor.identifier).any_times
        mock.proxy(@graph).add_edge(@actor, @actor.identifier)
        
        @actor.formats.each do |lang|
          mock.proxy(@graph).add_node(lang).any_times
          mock.proxy(@graph).add_edge(@actor, lang)
        end
      end
      
      it "creates nodes in a graph" do
        @actor.create_nodes_in(@graph)
      end
      
      it "creates nodes for its messge passing systems and edges in a graph" do
        message_passing_system = new_message_passing_system(:actors => [@actor])
        
        mock(message_passing_system).create_nodes_in(@graph)
        mock(@graph).add_edge.with_any_args
  
        @actor.create_nodes_in(@graph)
      end
      
      it "creates nodes for its communication needs" do
        communication_need = new_communication_need(@actor)
        
        mock(communication_need).create_nodes_in(@graph)
        mock(@graph).add_edge.with_any_args
  
        @actor.create_nodes_in(@graph)
      end
      
      it "creates nodes for its language translations" do
        language_translation = new_language_translation(:actor => @actor)
        
        mock(language_translation).create_nodes_in(@graph)
        mock(@graph).add_edge.with_any_args
  
        @actor.create_nodes_in(@graph)
      end
      
      it "creates nodes for its known addresses" do
        @actor.known_addresses << new_address
        
        @actor.known_addresses.each do |address|
          mock(@graph).add_edge(@actor, address)
        end
  
        @actor.create_nodes_in(@graph)
      end
      
    end
    
    it "only adds a message passing system once" do
      other_actor = new_actor(:name => "Other actor")
      message_passing_system = new_message_passing_system(:actors => [@actor, other_actor])

      @actor.create_nodes_in(@graph)
      other_actor.create_nodes_in(@graph)

      @graph.node_map.count.should eql(@graph.node_count)
    end
  end
  
end