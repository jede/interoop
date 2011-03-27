require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Interoop do
  it "can be instantiated" do
    interoop = Interoop.new
    interoop.should_not be_nil
  end
  
  it "can analyze communication needs" do
    interoop = Interoop.new
    interoop.analyze new_communication_need
  end
  
  it "can visualize actors" do
    interoop = Interoop.new
    # interoop.visualize new_actor, new_actor <- breaks tests because of Graphviz rendering not compatible with autotest
    interoop.should respond_to(:visualize)
  end
  
  it "loads a file" do
    interoop = Interoop.load(File.expand_path(File.dirname(__FILE__) + '/fixtures/test_case.rb'))
    interoop.should_not be_nil
  end
end