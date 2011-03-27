require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Interoop::LanguageTranslation do
  before :each do
    @language_translation = new_language_translation
  end
  
  it "has two languageges" do
    @language_translation.first_language.should_not be_nil
    @language_translation.second_language.should_not be_nil
  end
  
  it "has an actor" do
    @language_translation.actor.should_not be_nil
  end
end