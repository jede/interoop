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
    @communication_need.path_exists?.should eql(false)
    @message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b])
    @communication_need.path_exists?.should eql(true)
  end
  
  it "creates nodes in a graph" do
    @graph = Interoop::Graph.new(:G)
    
    mock(@graph).add_node(@communication_need.reference_language).any_times
    mock(@graph).add_node(@communication_need).any_times
    mock(@graph).add_edge.with_any_args
    
    @communication_need.create_nodes_in(@graph)
  end
end