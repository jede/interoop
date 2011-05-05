require File.expand_path(File.dirname(__FILE__) + '/../../ics_spec_helper')

describe Interoop::Ics::Language do
  before :each do
    @language = new_language
  end
  
  it "has a name" do
    @language.name.should_not be_empty
  end
end