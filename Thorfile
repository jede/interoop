$: << "./"
$: << "./lib/"
require "init"

class Interoop < Thor
  desc "load [PATH]", "Load and run a file with interoop statements"
  def load(path)
    ::Interoop.load(path)
  end
end