require File.expand_path(File.dirname(__FILE__) + '/../../ics_spec_helper')

describe Interoop::Ics::ReferenceLanguage do
  before :each do
    @reference_language = new_reference_language
  end
  
  it "has communication needs" do
    @reference_language.communication_needs.should be_an(Enumerable)
  end
  
  it "has a name" do
    @reference_language.name.should_not be_empty
  end
end