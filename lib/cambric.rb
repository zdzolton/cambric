require 'erb'
require 'yaml'

class Cambric
  
  def initialize(path)
    @config = YAML::load(ERB.new(IO.read(path)).result)
  end
  
  def config
    @config
  end
  
end