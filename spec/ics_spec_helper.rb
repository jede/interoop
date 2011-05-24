require "spec_helper"
Interoop.load_framework("ics")

def abstract_actor_options
  {
    :distorts_message => 0.0, 
    :drops_message => 0.0, 
    :is_available => 1.0
  }
end

def new_actor(options = {})
  options = {:name => "Actor nr #{NumberGenerator.next}", :formats => [new_language]}.merge(abstract_actor_options).merge(options)
  Interoop::Ics::Actor.new(options)
end

def new_address
  new_actor.identifier
end

def new_message_passing_system(options = {})
  options = {:name => "Router nr #{NumberGenerator.next}", :addressing_language => new_language, :actors => [new_actor], :formats => [new_language]}.merge(abstract_actor_options).merge(options)
  Interoop::Ics::MessagePassingSystem.new(options)
end

def new_language
  Interoop::Ics::Language.new(:name => "Language nr #{NumberGenerator.next}")
end

def new_language_translation(options)
  options = {:actor => new_actor, :from => new_language, :to => new_language, :correct => 1.0}.merge(options)
  Interoop::Ics::LanguageTranslation.new(options)
end

def new_reference_language
  Interoop::Ics::ReferenceLanguage.new(:name => "Reference Language nr #{NumberGenerator.next}")
end

def new_communication_need(*args)
  args = [new_actor, new_actor] if args.empty?
  subject = args.shift
  Interoop::Ics::CommunicationNeed.new(:subject => subject, :actors => args, :reference_language => new_reference_language)
end