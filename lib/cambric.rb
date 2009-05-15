require 'erb'
require 'yaml'

class Cambric
  
  def initialize(string)
    @config = YAML::load(ERB.new(string).result)
  end
  
  def config
    @config
  end
  
end