require 'interoop/visualizer'
require 'interoop/entity'

class Interoop
  class Alt < Visualizer
    def initialize(*args)
      super
      yield self, binding if block_given?
    end
  end
end

[ 'actor',
  'chain_proxy',
  'active_actor',
  'data',
  'need',
  'data_need',
  'communication_need',
  'exchange',
  'relay_actor',
  'transformation'
].each do |file|
    require "interoop/alt/#{file}"
end
  