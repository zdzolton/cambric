require 'erb'
require 'yaml'

class Cambric
  
  def initialize(io)
    @config = YAML::load(ERB.new(io.read).result)
  end
  
  def config
    @config
  end
  
end