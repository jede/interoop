require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Interoop::CommunicationNeed do
  before :each do
    @actor_a = new_actor
    @actor_b = new_actor
    @communication_need = new_communication_need(@actor_a, @actor_b)
  end
  
  it "can be created between actors" do
    @communication_need.should_not be_nil
  end
  
  it "updates the actors of the communication need" do
    @actor_a.communication_needs.last.class.should eql(Interoop::CommunicationNeed)
    @actor_b.communication_needs.last.class.should eql(Interoop::CommunicationNeed)
  end
  
  it "has a reference language" do
    @communication_need.reference_language.should_not be_nil
  end
  
  it "has addressing needs" do
    @communication_need.addressing_needs.should be_an(Enumerable)
  end
  
  it "can calculate if a path exists between its two actors or not" do
    @communication_need.path_exists.should eql(0.0)
    @message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b])
    @communication_need.path_exists.should eql(1.0)
  end
  
  it "creates nodes in a graph" do
    @graph = Interoop::Graph.new(:G)
    
    mock(@graph).add_node(@communication_need.reference_language).any_times
    mock(@graph).add_node(@communication_need).any_times
    mock(@graph).add_edge.with_any_args
    
    @communication_need.create_nodes_in(@graph)
  end
  
  describe "path available" do
    it "can calculate the probability that a path is availible" do
      @message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :is_available => 1.0)
      @communication_need.path_available.should == 1.0
      
      @message_passing_system.is_available = 0.5
      @communication_need.path_available.should == 0.5
      
      @actor_b.is_available = 0.5
      @communication_need.path_available.should == 0.25
    end
    
    it "can find the most probable path" do
      message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :is_available => 0.9)
      other_message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :is_available => 0.5)
      
      @communication_need.path_available.should == 0.9
    end
  end
  
  describe "common language" do
    it "can calculate that a common language exists between the actors" do
      message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b])
      @communication_need.common_language_exists.should == 0.0
      
      common_lang = new_language
      @actor_a.formats << common_lang
      @actor_b.formats << common_lang
      message_passing_system.formats << common_lang
      
      @communication_need.common_language_exists.should == 1.0
    end
  end
end