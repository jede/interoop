require 'interoop/alt/actor'

class Interoop::Alt
  class ActiveActor < Actor
    attr_accessor :creates, :data_needs, :transformations
    
    def initialize(params = {})
      super
      @data_needs ||= []
      @creates ||= []
      @transformations ||= []
      
      update_data!
      
    end
    
    def transformations(options = {})
      if options[:from]
        @transformations.find_all{|t| t.from == options[:from]}
      else
        @transformations
      end
    end
    
    def create_nodes_in(graph)
      super
      create_nodes_for_relations(graph, :data_needs, :creates, :transformations)
    end
    
    def sends(data)
      ChainProxy.new(self).tap{|p| p.sends(data) }
    end
    
    def needs(data, options = {})
      options[:name] ||= "#{data} need"
      data_need = DataNeed.new(options.merge(actor: self, data: data))
      CommunicationNeed.find_or_create_by_group(options[:group]).add_need(data_need) if options[:group]
      self.data_needs << data_need
    end
    
    def transforms(options)
      self.transformations << Transformation.new(options.merge(:actor => self))
    end
    
    protected
    
    def update_data!
      creates.each do |data|
        data.creator = self
      end
    end
  end
end