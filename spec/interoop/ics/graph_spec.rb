require File.expand_path(File.dirname(__FILE__) + '/../../ics_spec_helper')

describe Interoop::Graph do
  before :each do
    @graph = Interoop::Graph.new(:G)
  end
  
  it "cannot add nil" do
    @graph.add_node(nil).should be_nil
    @graph.node_count.should eql(0)
  end
  
  it "can check if it has a node" do
    actor = new_actor
    @graph.add_node(actor)
    @graph.has_node?(actor).should eql(true)
  end
  
  it "shall use attributes if there are any" do
    actor = new_actor
    mock.proxy(actor).attributes
    @graph.add_node(actor)
  end
  
  it "can compile a valid label" do
    @graph.compile_label({a: "b", b: "c"}).should eql(" | a: b | b: c")
  end
end
