require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Interoop::Actor do
  before :each do
    @actor = new_actor
  end
  
  it "can receive distorts_message, drops_message and is_available" do
    @actor.distorts_message = 0.5
    @actor.drops_message = 0.5
    @actor.is_available = 0.5
  end
  
  it "sets distorts_message, drops_message and is_available to default values" do
    other_actor = Interoop::Actor.new
    other_actor.distorts_message.should == 0.0
    other_actor.drops_message.should == 0.0
    other_actor.is_available.should == 1.0
  end
  
  it "can have communication needs" do
    @actor.communication_needs.should be_an(Enumerable)
  end
  
  it "has communication mediums" do
    @actor.communication_mediums.should be_an(Enumerable)
  end
  
  it "has formats" do
    @actor.formats.should be_an(Enumerable)
    @actor.formats.should_not be_empty
  end
  
  it "adds formats only once" do
    lang = new_language    
    count = @actor.formats.count
    
    @actor.add_format(lang)
    @actor.add_format(lang)
    
    @actor.formats.count.should eql(count + 1)
  end
  
  it "has language translations" do
    @actor.language_translations.should be_an(Enumerable)
  end
  
  it "has an identifier" do
    @actor.identifier.should_not be_nil
  end
  
  it "sets itself as actor on the given identifier" do
    @actor.identifier.actor.should eql(@actor)
  end
  
  it "has known addresses" do
    @actor.known_addresses.should be_an(Enumerable)
  end
  
  it "can calculate the propability that it reaches another actor" do
    other_actor = new_actor(:name => "Other actor")
    @actor.reaches(other_actor).should eql(0.0)
    message_passing_system = new_message_passing_system(:actors => [other_actor, @actor])
    @actor.reaches(other_actor).should eql(1.0)
  end
  
  it "can calculate the propability that it reaches another actor, without using some actor or message passing system" do
    other_actor = new_actor
    message_passing_system = new_message_passing_system(:actors => [other_actor, @actor])

    @actor.reaches(other_actor).should eql(1.0)
    @actor.reaches(other_actor, :without_using => [message_passing_system]).should eql(0.0)
  end
  
  it "calcualtes the most avalible path to another actor" do
    other_actor = new_actor
    
    @actor.most_available_path_to(other_actor).should eql([])
    message_passing_system = new_message_passing_system(:actors => [@actor, other_actor], :is_available => 0.8)
    @actor.most_available_path_to(other_actor).should eql([@actor, message_passing_system, other_actor])
    
    other_message_passing_system = new_message_passing_system(:actors => [@actor, other_actor], :is_available => 0.9)
    @actor.most_available_path_to(other_actor).should eql([@actor, other_message_passing_system, other_actor])
    
  end

  describe "graphing" do
    before :each do
      @graph = Interoop::Graph.new(:G)
    end
    
    describe "with mock" do
      before :each do
        
        mock.proxy(@graph).add_node(@actor).any_times
        
        mock.proxy(@graph).add_node(@actor.identifier).any_times
        mock.proxy(@graph).add_edge(@actor, @actor.identifier)
        
        @actor.formats.each do |lang|
          mock.proxy(@graph).add_node(lang).any_times
          mock.proxy(@graph).add_edge(@actor, lang)
        end
      end
      
      it "creates nodes in a graph" do
        @actor.create_nodes_in(@graph)
      end
      
      it "creates nodes for its messge passing systems and edges in a graph" do
        message_passing_system = new_message_passing_system(:actors => [@actor])
        
        mock(message_passing_system).create_nodes_in(@graph)
        mock(@graph).add_edge.with_any_args
  
        @actor.create_nodes_in(@graph)
      end
      
      it "creates nodes for its communication needs" do
        communication_need = new_communication_need(@actor)
        
        mock(communication_need).create_nodes_in(@graph)
        mock(@graph).add_edge.with_any_args
  
        @actor.create_nodes_in(@graph)
      end
      
      it "creates nodes for its language translations" do
        language_translation = new_language_translation(:actor => @actor)
        
        mock(language_translation).create_nodes_in(@graph)
        mock(@graph).add_edge.with_any_args
  
        @actor.create_nodes_in(@graph)
      end
      
      it "creates nodes for its known addresses" do
        @actor.known_addresses << new_address
        
        @actor.known_addresses.each do |address|
          mock(@graph).add_edge(@actor, address)
        end
  
        @actor.create_nodes_in(@graph)
      end
      
    end
    
    it "only adds a message passing system once" do
      other_actor = new_actor(:name => "Other actor")
      message_passing_system = new_message_passing_system(:actors => [@actor, other_actor])

      @actor.create_nodes_in(@graph)
      other_actor.create_nodes_in(@graph)

      @graph.node_map.count.should eql(@graph.node_count)
    end
  end
  
  describe "shorthand dsl" do
    it "can create translation with 'translates'" do
      lang1 = new_language
      lang2 = new_language
      
      @actor.translates(from: lang1, to: lang2)
      trans = @actor.language_translations.last
      trans.from.should eql(lang1)
      trans.to.should eql(lang2)
    end
    
    it "can create a format with 'sends'" do
      lang = new_language
      @actor.sends(lang)
      @actor.formats.should include(lang)
    end
    
    it "can chain 'sends' with 'through' to set up a relation to a message passing system" do
      language = new_language
      message_passing_system = new_message_passing_system
      
      @actor.sends(language).through(message_passing_system)
      message_passing_system.actors.should include(@actor)
      message_passing_system.formats.should include(language)
    end
    
    it "can chain 'sends', 'through' and 'to' in order to set up a relation to another actor" do
      language = new_language
      message_passing_system = new_message_passing_system
      other_actor = new_actor
      
      @actor.sends(language).through(message_passing_system).to other_actor
      message_passing_system.actors.should include(other_actor)
      other_actor.formats.should include(language)
    end
    
    it "sets up a communication need" do
      other_actor = new_actor
      @actor.needs_to_communicate_with(other_actor)
      @actor.communication_needs.last.actors.should include(other_actor)
    end
  end
  
end