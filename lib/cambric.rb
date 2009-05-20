require 'couchrest'
require 'uri'

class Cambric
  
  attr_reader :design_doc_name, :db_dir, :environment
  
  def initialize
    config = Configurator.new
    yield config if block_given?
    @databases = config.initialize_databases
    @design_doc_name = config.design_doc_name
    @db_dir = config.db_dir
    @environment = config.environment
  end
  
  def create_all_databases
    @databases.each_pair do |name,db|
      name_with_env = "#{name}-#{@environment}"
      begin
        db.server.create_db name_with_env
      rescue
        db.server.database(name_with_env).recreate!
      end
    end
  end
  
  def [](database)
    @databases[database.to_sym]
  end
  
end

class Cambric::Configurator
  
  attr_accessor :design_doc_name, :db_dir, :environment, :databases
  
  def initialize
    @design_doc_name = 'cambric'
    @db_dir = './couchdb'
    @environment = 'development'
    @databases = {}
  end
  
  def initialize_databases
    dbs_by_name = {}
    @databases.each_pair do |db,urls_by_env|
      urls_by_env.keys.map!{ |env| env.to_sym }
      uri = URI.parse urls_by_env[@environment.to_sym]
      dbs_by_name[db.to_sym] = initialize_database uri
    end
    dbs_by_name
  end
  
private

  def initialize_database uri
    server = CouchRest.new("#{uri.scheme}://#{uri.host}:#{uri.port}")
    database = server.database uri.path.gsub(/^\//, '')
    # database.extend AssumeDesignDocName
    # database.design_doc_name = @design_doc_name
    database
  end
  
end

# module Cambric::AssumeDesignDocName
# 
#   attr_accessor :design_doc_name
#   
#   def view name, options={}, &block
#     super "#{@design_doc_name}/#{name}", options, &block
#   end
#   
# end
