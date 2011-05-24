require File.expand_path(File.dirname(__FILE__) + '/../../alt_spec_helper')

describe Interoop::Alt::DataNeed do
  before(:each) do
    @data = new_data
    @actor = new_actor(creates: [@data])
    @other_data = new_data
    @other_actor = new_actor(creates: [@other_data], available: 0.5)
    @exchange = new_exchange(from: @actor, to: @other_actor, data: @data)
    @other_exchange = new_exchange(from: @other_actor, to: @actor, data: @other_data)
    
    @data_need = new_data_need(actor: @actor, data: @other_data)
  end
  
  it "calculates the availability" do
    
  end
end