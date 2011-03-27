require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Interoop::Language do
  before :each do
    @language = new_language
  end
  
  it "has many formats" do
    @language.formats.should be_an(Enumerable)
  end
  
  it "has a name" do
    @language.name.should_not be_empty
  end
end