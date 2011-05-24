require 'interoop/entity'
require 'interoop/graph'

class Interoop
  
  def self.framework_class
    @framework_class
  end
  
  def self.load_framework(f)
    require "interoop/#{f}"
    @framework_class = eval(f.capitalize)
  end
  
  def self.load(path)
    /(.*\/)?(?<name>\w+)\.(?<framework>\w+).rb/ =~ path # path = "workbench/test.rb" => name = "test"
    
    load_framework(framework).new(name) do |interoop, binding|
      File.open(path) do |f|
         eval f.readlines.join(' '), binding
      end
    end
  end
end