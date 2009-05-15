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
    @config.each_pair do |db,env_hash|
      raise "No Cambric config for database '#{db}', environment '#{environment}'" unless env_hash.has_key?(environment)
      db_name = "#{db}-#{environment}"
      begin
        server.create_db(db_name)
      rescue
        server.database(db_name).recreate!
      end
    end
  end
  
end