require 'erb'
require 'yaml'

module Cambric
  
  def self.load_config(path)
    @config = YAML::load(ERB.new(IO.read(path)).result)
  end
  
  def self.config
    @config
  end
  
end