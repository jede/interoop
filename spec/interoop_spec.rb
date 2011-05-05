require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Interoop do
  it "loads a file" do
    mock(Interoop).load_framework("frmwrk") { Object }
    interoop = Interoop.load(File.expand_path(File.dirname(__FILE__) + '/fixtures/test_case.frmwrk.rb'))
    interoop.should_not be_nil
  end
end