require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Interoop::CommunicationNeed do
  before :each do
    @actor_a = Interoop::Actor.new("Actor A")
    @actor_b = Interoop::Actor.new("Actor B")
  end
  it "can be created betwee actors" do
    Interoop::CommunicationNeed.between(@actor_a, @actor_b)
  end
  
  it "updates the actors of the communication need" do
    Interoop::CommunicationNeed.between(@actor_a, @actor_b)
    @actor_a.communication_needs.last.class.should eql(Interoop::CommunicationNeed)
    @actor_b.communication_needs.last.class.should eql(Interoop::CommunicationNeed)
  end
end