require 'couchrest'
require 'uri'

Dir.glob(File.join(File.dirname(__FILE__), 'cambric/**.rb')).each{ |f| require f }

module Cambric
  
  def self.design_doc_name
    @design_doc_name
  end
  
  def self.db_dir
    @db_dir
  end
  
  def self.environment
    @environment
  end

  def self.environment= value
    @config.environment = value
    @databases = @config.initialize_databases
    @environment = @config.environment
  end
  
  def self.configure
    @config = Configurator.new
    yield @config if block_given?
    @databases = @config.initialize_databases
    @design_doc_name = @config.design_doc_name
    @db_dir = @config.db_dir
    @environment = @config.environment
  end
  
  def self.create_databases!
    @databases.each_pair do |name,db|
      begin
        db.server.create_db db.name
      rescue
        db.server.database(db.name).recreate!
      end
    end
  end
  
  def self.create_databases
    @databases.each_pair{ |name,db| db.server.create_db db.name rescue nil }
  end
  
  def self.[](database)
    @databases[database.to_sym]
  end
  
  def self.push_design_docs
    @databases.keys.each{ |db| push_design_doc_for db.to_s }
  end
  
  def self.prepare_databases
    create_databases
    push_design_docs
  end
  
  def self.prepare_databases!
    create_databases!
    push_design_docs
  end
   
private

  def self.push_design_doc_for database
    design_doc_path = File.join @db_dir, database
    if File.exist?(design_doc_path)
      `couchapp push #{design_doc_path} #{@design_doc_name} #{self[database].uri}`
    end
  end
    
end
