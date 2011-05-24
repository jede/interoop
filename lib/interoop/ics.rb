require 'interoop/visualizer'
require 'interoop/entity'


class Interoop
  class Ics < Visualizer
    def initialize(*args)
      super
      yield self, binding if block_given?
    end
  end
end

require 'interoop/ics/chain_proxy'
require 'interoop/ics/actor'
require 'interoop/ics/communication_need'
require 'interoop/ics/message_passing_system'
require 'interoop/ics/language'
require 'interoop/ics/language_translation'
require 'interoop/ics/reference_language'
require 'interoop/ics/address'
