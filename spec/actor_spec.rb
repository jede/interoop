require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Interoop::Actor do
  before :each do
    @actor = Interoop::Actor.new("Actor")
  end
  
  it "can receive distorts_message, drops_message and is_available" do
    @actor.distorts_message = 0.5
    @actor.drops_message = 0.5
    @actor.is_available = 0.5
  end
  
  it "can have communication needs" do
    @actor.communication_needs.should be_empty
  end
end