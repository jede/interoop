require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Interoop::LanguageTranslation do
  before :each do
    @actor = new_actor
    @language_translation = new_language_translation(:actor => @actor)
  end
  
  it "has two languageges" do
    @language_translation.from.should_not be_nil
    @language_translation.to.should_not be_nil
  end
  
  it "has an actor" do
    @language_translation.actor.should_not be_nil
  end
  
  it "adds itself on the actor" do
    @actor.language_translations.should include(@language_translation)
  end
    
  it "is assigned with a correct probability" do
    @language_translation.correct.should_not be_nil
  end
end