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
  
  def self.[](database_name)
    @databases[database_name.to_sym]
  end
  
  def self.push_design_docs ddoc_name=nil
    @databases.keys.each{ |db_sym| push_design_doc_for db_sym, ddoc_name }
  end
  
  def self.prepare_databases
    create_databases
    push_design_docs
  end
  
  def self.prepare_databases!
    create_databases!
    push_design_docs
  end
  
  def self.prime_view_changes_in_temp
    ddoc_name = "#{@design_doc_name}-temp"
    push_design_docs ddoc_name
    @databases.keys.map do |db_name|
      Thread.new{ prime_views_for @databases[db_name], ddoc_name }
    end.each{ |t| t.join }
  end
  
private

  def self.prime_views_for database, ddoc_name=nil
    ddoc = database.get "_design/#{ddoc_name}"
    view_name, view_def = ddoc['views'].first
    opts = { :limit => 1 }
    opts[:reduce] = false if view_def['reduce']
    view_url = "#{database.root}/_design/#{ddoc_name}/_view/#{view_name}"
    %x[curl --silent '#{CouchRest.paramify_url view_url, opts}']
  end

  def self.push_design_doc_for database_name, ddoc_name=nil
    database = database_name.to_s
    design_doc_path = File.join @db_dir, database
    if File.exist?(design_doc_path)
      fm = FileManager.new self[database].name, self[database].host
      fm.push_app design_doc_path, ddoc_name || @design_doc_name
    end
  end
    
end
