require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Interoop::Address do
  before :each do
    @address = new_address
  end
  
  it "has an actor" do
    @address.actor.should_not be_nil
  end
end