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
    server = CouchRest::Server.new("http://localhost:5984")
    @config.keys.each do |db|
      begin
        server.create_db(db)
      rescue
        server.database(db).recreate!
      end
    end
  end
  
end