require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Interoop do
  it "can be instantiated" do
    interoop = Interoop.new
    interoop.should_not be_nil
  end
end