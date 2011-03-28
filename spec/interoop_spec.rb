require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Interoop do
  before :each do
    @interoop = Interoop.new("Test")
  end
  
  it "can be instantiated" do
    @interoop.should_not be_nil
  end
  
  it "can visualize actors" do
    # interoop.visualize new_actor, new_actor <- breaks tests because of Graphviz rendering not compatible with autotest
    @interoop.should respond_to(:visualize)
  end
  
  it "loads a file" do
    interoop = Interoop.load(File.expand_path(File.dirname(__FILE__) + '/fixtures/test_case.rb'))
    interoop.should_not be_nil
  end
  
  it "generates a graph from actors" do
    actor_a = new_actor
    actor_b = new_actor
    
    mock.proxy(actor_a).create_nodes_in.with_any_args
    mock.proxy(actor_b).create_nodes_in.with_any_args
    
    @interoop.generate_graph([actor_a, actor_b])
  end
end