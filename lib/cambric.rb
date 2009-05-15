require 'erb'
require 'yaml'

class Cambric
  
  def initialize(io)
    @config = YAML::load(ERB.new(io.read).result)
  end
  
  def config
    @config
  end
  
  def create_all_databases_for environment
    CouchRest::Server.new("http://localhost:5984").create_db('bar')
  rescue
    CouchRest::Server.new("http://localhost:5984").database('bar').recreate!
  end
  
end