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
  
  it "can calculate if it reaches another actor" do
    other_actor = new_actor(:name => "Other actor")
    @actor.reaches?(other_actor).should eql(false)
    message_passing_system = new_message_passing_system(:actors => [other_actor, @actor])
    @actor.reaches?(other_actor).should eql(true)
  end
  
  it "can calculate if it reaches another actor, without using some actor or message passing system" do
    other_actor = new_actor
    message_passing_system = new_message_passing_system(:actors => [other_actor, @actor])

    @actor.reaches?(other_actor).should eql(true)
    @actor.reaches?(other_actor, :without_using => [message_passing_system]).should eql(false)
  end
  
end