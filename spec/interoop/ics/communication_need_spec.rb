require File.expand_path(File.dirname(__FILE__) + '/../../ics_spec_helper')

describe Interoop::Ics::CommunicationNeed do
  before :each do
    @actor_a = new_actor
    @actor_b = new_actor
    @communication_need = new_communication_need(@actor_a, @actor_b)
  end
  
  describe "find or build" do
    it "can find or create instances" do
      com_need = Interoop::Ics::CommunicationNeed.find_or_build(id: :test, subject: @actor_a, :actors => [@actor_b])
      com_need.should be_a(Interoop::Ics::CommunicationNeed)
      Interoop::Ics::CommunicationNeed.find_or_build(id: :test, subject: @actor_a, :actors => [@actor_b]).should eql(com_need)
      Interoop::Ics::CommunicationNeed.find_or_build(subject: @actor_a, :actors => [@actor_b]).should_not eql(com_need)
    end

    it "merges actors" do
      @actor_c = new_actor
      com_need = Interoop::Ics::CommunicationNeed.find_or_build(id: :test, subject: @actor_a, :actors => [@actor_b])
      com_need = Interoop::Ics::CommunicationNeed.find_or_build(id: :test, subject: @actor_a, :actors => [@actor_c])
      com_need.actors.should include(@actor_b)
      com_need.actors.should include(@actor_c)
    end
    
    it "can convert names to ids" do
      com_need = Interoop::Ics::CommunicationNeed.find_or_build(name: "Test", subject: @actor_a, :actors => [@actor_b])
      com_need.should be_a(Interoop::Ics::CommunicationNeed)
      Interoop::Ics::CommunicationNeed.find_or_build(name: "Test", subject: @actor_a, :actors => [@actor_b]).should eql(com_need)
      Interoop::Ics::CommunicationNeed.find_or_build(subject: @actor_a, :actors => [@actor_b]).should_not eql(com_need)
      
    end
  end
  
  it "can be created between actors" do
    @communication_need.should_not be_nil
  end
  
  it "updates the actors of the communication need" do
    @actor_a.communication_needs.last.class.should eql(Interoop::Ics::CommunicationNeed)
    @actor_b.communication_needs.last.class.should eql(Interoop::Ics::CommunicationNeed)
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
    @graph = Interoop::Ics::Graph.new(:G)
    
    mock(@graph).add_node(@communication_need.reference_language).any_times
    mock(@graph).add_node(@communication_need).any_times
    mock(@graph).add_edge.with_any_args
    
    @communication_need.create_nodes_in(@graph)
  end
  
  describe "path available" do
    it "finds the most avalible path" do
      message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :is_available => 0.9)
      other_message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :is_available => 0.5)
      
      @communication_need.path_available.should == 0.9
    end
    
    it "handles multiple actors" do
      @actor_c = new_actor
      @communication_need.actors << @actor_c
      
      message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :is_available => 0.9)
      other_message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_c], :is_available => 0.5)
      
      @communication_need.path_available.should == 0.9 * 0.5
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
  
  it "can calculate the probability that a path is availible" do
    @message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :is_available => 1.0)
    @communication_need.path_available.should == 1.0
    
    @message_passing_system.is_available = 0.5
    @communication_need.path_available.should == 0.5
    
    @actor_b.is_available = 0.5
    @communication_need.path_available.should == 0.25
  end
  
  it "can calculate the probability that a path drops a message" do
    @message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :drops_message => 1.0)
    @communication_need.drops_message.should == 1.0
    
    @message_passing_system.drops_message = 0.5
    @communication_need.drops_message.should == 0.5
    
    @actor_b.drops_message = 0.5
    @communication_need.drops_message.should == 0.75
  end
  
  it "can calculate the probability that a syntactic distortion occurs" do
    @message_passing_system = new_message_passing_system(:actors => [@actor_a, @actor_b], :distorts_message => 1.0)
    @communication_need.syntactic_distortion.should == 1.0
    
    @message_passing_system.distorts_message = 0.5
    @communication_need.syntactic_distortion.should == 0.5
    
    @actor_b.distorts_message = 0.5
    @communication_need.syntactic_distortion.should == 0.75
  end
  
  it "can calculate if a language chain exists" do
    @xml = new_language
    @json = new_language
    @message_passing_system_a = new_message_passing_system
    @message_passing_system_b = new_message_passing_system
    @actor_c = new_actor
    @actor_a.sends(@xml).through(@message_passing_system_a).to @actor_b
    @actor_b.sends(@json).through(@message_passing_system_b).to @actor_c
    
    @communication_need = @actor_a.needs_to_communicate_with @actor_c
    
    @communication_need.language_chain_exists.should == 0.0
    @actor_b.translates(:from => @xml, :to => @json)
    @communication_need.language_chain_exists.should == 1.0
  end
  
  it "can calculate if symantic distortion" do
    @xml = new_language
    @json = new_language
    @message_passing_system_a = new_message_passing_system
    @message_passing_system_b = new_message_passing_system
    @actor_c = new_actor
    @actor_a.sends(@xml).through(@message_passing_system_a).to @actor_b
    @actor_b.sends(@json).through(@message_passing_system_b).to @actor_c
    
    @communication_need = @actor_a.needs_to_communicate_with @actor_c
    
    translation = @actor_b.translates(:from => @xml, :to => @json, :correct => 1.0)
    @communication_need.semantically_correct.should == 1.0
    
    translation.correct = 0.5
    @communication_need.semantically_correct.should == 0.5
  end
  
end