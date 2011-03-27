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
  
end