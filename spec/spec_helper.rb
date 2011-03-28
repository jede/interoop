require './init.rb'
require 'rspec'

RSpec.configure do |config|
  config.mock_with :rr
end

class NumberGenerator
  @@number = 1
  
  def self.next
    @@number += 1
  end
end

def new_actor(options = {})
  options = {:name => "Actor nr #{NumberGenerator.next}", :formats => [new_language]}.merge(options)
  Interoop::Actor.new(options)
end

def new_address
  new_actor.identifier
end

def new_message_passing_system(options = {})
  options = {:name => "Router nr #{NumberGenerator.next}", :addressing_language => new_language, :actors => [new_actor], :formats => [new_language]}.merge(options)
  Interoop::MessagePassingSystem.new(options)
end

def new_language
  Interoop::Language.new(:name => "Language nr #{NumberGenerator.next}")
end

def new_language_translation(options)
  options = {:actor => new_actor, :from => new_language, :to => new_language}.merge(options)
  Interoop::LanguageTranslation.new(options)
end

def new_reference_language
  Interoop::ReferenceLanguage.new(:name => "Reference Language nr #{NumberGenerator.next}")
end

def new_communication_need(*args)
  args = [new_actor, new_actor] if args.empty?
  Interoop::CommunicationNeed.new(:actors => args, :reference_language => new_reference_language)
end