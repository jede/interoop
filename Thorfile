$: << "./"
$: << "./lib/"
require "init"

class Interoop < Thor
  desc "visualize [PATH]", "Load and run a file with interoop statements"
  def visualize(path)
    ::Interoop.load(path).visualize!
  end
end