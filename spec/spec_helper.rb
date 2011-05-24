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

