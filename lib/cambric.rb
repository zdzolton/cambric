require 'erb'
require 'yaml'
require 'couchrest'

class Cambric
  
  def initialize(yaml_config_io, options={})
    options.keys.map!{ |k| k.to_sym }
    @config = YAML::load(ERB.new(yaml_config_io.read).result)
    validate_options_hash options
    @environment = options[:environment]
    @design_doc_name = options[:design_doc]
    validate_environment_exists_for_all_dbs
  end
  
  def config
    @config
  end
  
  def environment
    @environment
  end
  
  def design_doc_name
    @design_doc_name
  end
  
  def [](db)
    @database_cache ||= {}
    @database_cache[db.to_sym] ||= CouchRest.new("localhost:5984").database("#{db}-#{@environment}")
  end
  
  def create_all_databases
    server = CouchRest::Server.new("http://localhost:5984")
    @config.each_pair do |db,env_hash|
      db_name = "#{db}-#{@environment}"
      begin
        server.create_db(db_name)
      rescue
        server.database(db_name).recreate!
      end
    end
  end
  
  # def push_all_design_docs
  # end
  
private

  # def push_design_doc_for database
  # end

  def validate_options_hash options
    %w(environment design_doc).each do |opt_key|
      unless options.has_key?(opt_key.to_sym)
        raise "Must provide :#{opt_key} option"
      end
    end
  end

  def validate_environment_exists_for_all_dbs
    @config.each_pair do |db,env_hash|
      raise "No Cambric config for database '#{db}', environment '#{@environment}'" unless env_hash.has_key?(@environment)
    end
  end
  
end