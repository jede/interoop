require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Interoop do
  it "can be instantiated" do
    interoop = Interoop.new
    interoop.should_not be_nil
  end
  
  it "can add Actors" do
    interoop = Interoop.new
    system_a = Interoop::Actor.new("System A")
    interoop.add system_a
  end
  
  it "increases count when adding an Actor" do
    interoop = Interoop.new
    system_a = Interoop::Actor.new("System A")
    interoop.actor_count.should eql(0)
    interoop.add system_a
    interoop.actor_count.should eql(1)
  end
end