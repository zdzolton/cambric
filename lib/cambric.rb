require 'erb'
require 'yaml'
require 'couchrest'

class Cambric
  
  attr_reader :config
  attr_accessor :environment, :design_doc_name, :db_dir
  
  def initialize(yaml_config_io)
    # options.keys.map!{ |k| k.to_sym }
    @config = YAML::load(ERB.new(yaml_config_io.read).result)
    # validate_options_hash options
    # @environment = options[:environment]
    # @design_doc_name = options[:design_doc]
    # @db_dir = options[:db_dir] || './couchdb'
    # validate_environments_exists_for_all_dbs
  end
  
  def [](db)
    initialize_databases unless @databases
    @databases[db.to_sym]
  end
  
  def create_all_databases
    initialize_databases unless @databases
    @databases.each_pair do |db_name,db|
      name_with_env = "#{db_name}-#{@environment}"
      begin
        db.server.create_db name_with_env
      rescue
        db.server.database(name_with_env).recreate!
      end
    end
    push_all_design_docs
  end
  
  def push_all_design_docs
    @databases.keys.each{ |db| push_design_doc_for db.to_s }
  end
  
private

  def push_design_doc_for database
    design_doc_path = File.join @db_dir, database
    raise "Database directory #{design_doc_path} does not exist!" unless File.exist?(design_doc_path)
    `couchapp push #{design_doc_path} #{@design_doc_name} #{self[database].uri}`
  end

  def validate_options_hash options
    %w(environment design_doc).each do |opt_key|
      unless options.has_key?(opt_key.to_sym)
        raise "Must provide :#{opt_key} option"
      end
    end
  end

  def validate_environments_exists_for_all_dbs
    @config.each_pair do |db,env_hash|
      raise "No Cambric config for DB '#{db}' ENV '#{@environment}'" unless env_hash.has_key?(@environment)
    end
  end
  
  def initialize_databases
    @databases = {}
    @config.each_pair do |db_name,conn_by_env|
      conn_settings = conn_by_env[@environment] || {}
      host = conn_settings['host'] || 'localhost'
      port = conn_settings['port'] || 5984
      database = CouchRest.new("http://#{host}:#{port}").database("#{db_name}-#{@environment}")
      database.extend AssumeDesignDocName
      database.design_doc_name = @design_doc_name
      @databases[db_name.to_sym] = database
    end
  end
  
  module AssumeDesignDocName

    attr_accessor :design_doc_name
    
    def view name, options={}, &block
      super "#{@design_doc_name}/#{name}", options, &block
    end
    
  end
  
end
