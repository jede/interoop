require 'interoop/actor'
require 'interoop/communication_need'
require 'interoop/message_passing_system'
require 'interoop/language'
require 'interoop/language_translation'
require 'interoop/reference_language'
require 'interoop/address'

class Interoop
  def initialize
    @actors = []
    yield self, binding if block_given?
  end
  
  def analyze(communication_need)
    
  end
  
  def visualize(*actors)
    
  end
  
  def self.load(path)
    Interoop.new do |interoop, binding|
      File.open(path) do |f|
         eval f.readlines.join(' '), binding
      end
    end
  end
end