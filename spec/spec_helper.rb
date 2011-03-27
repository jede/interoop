require './init.rb'
require 'rspec'

def new_actor(options = {})
  options = {:name => "Actor", :identifier => Interoop::Address.new(), :formats => [new_language]}.merge(options)
  Interoop::Actor.new(options)
end

def new_address
  new_actor.identifier
end

def new_message_passing_system(options = {})
  options = {:name => "Router", :addressing_language => new_language, :actors => [new_actor]}.merge(options)
  Interoop::MessagePassingSystem.new(options)
end

def new_language
  Interoop::Language.new(:name => "XML")
end

def new_language_translation
  Interoop::LanguageTranslation.new(:actor => new_actor, :first_language => new_language, :second_language => new_language)
end

def new_reference_language
  Interoop::ReferenceLanguage.new(:name => "DHL order numbers?")
end

def new_communication_need(*args)
  args = [new_actor, new_actor] if args.empty?
  Interoop::CommunicationNeed.new(:actors => args, :reference_language => new_reference_language)
end