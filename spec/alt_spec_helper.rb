require "spec_helper"
Interoop.load_framework("alt")

def new_actor(params = {})
  Interoop::Alt::Actor.new(params.merge(name: "Actor nr #{NumberGenerator.next}"))
end

def new_data(params = {})
  Interoop::Alt::Data.new(params.merge(name: "Data nr #{NumberGenerator.next}"))
end

def new_data_need(params = {})
  Interoop::Alt::Data.new(params.merge(name: "DataNeed nr #{NumberGenerator.next}"))
end

def new_exchange(params = {})
  Interoop::Alt::Exchange.new(params.merge(name: "Exchange nr #{NumberGenerator.next}"))
end