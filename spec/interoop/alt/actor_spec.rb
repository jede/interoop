require File.expand_path(File.dirname(__FILE__) + '/../../alt_spec_helper')

describe Interoop::Alt::Actor do
  before(:each) do
    @data = new_data
    @actor = new_actor(creates: [@data])
    @other_data = new_data
    @other_actor = new_actor(creates: [@other_data], available: 0.5)
    @exchange = new_exchange(from: @actor, to: @other_actor, data: @data)
    @other_exchange = new_exchange(from: @other_actor, to: @actor, data: @other_data)
  end
  
  it "finds its exchanges" do
    @actor.exchanges.count.should eql(2)
    @actor.exchanges(:as => :receiver).should eql([@other_exchange])
  end
  
  it "finds neighbors sending certain data" do
    @actor.neighbors_sending(@data).should eql([])
    @actor.neighbors_sending(@other_data).should eql([@other_actor])
  end
  
  it "finds the path to the data" do
    @actor.most_available_path_to(@other_data).should eql([@other_exchange])
    @other_actor.most_available_path_to(@data).should eql([@exchange])
  end
  
  it "calculates availability" do
    @actor.path_available_to(@other_data).should eql(0.5)
  end
end