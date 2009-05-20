require 'couchrest'

class Cambric
  
  attr_reader :design_doc_name, :db_dir, :environment
  
  def initialize
    config = Configurator.new
    yield config if block_given?
    @design_doc_name = config.design_doc_name
    @db_dir = config.db_dir
    @environment = config.environment
  end
  
end

class Cambric::Configurator
  
  attr_accessor :design_doc_name, :db_dir, :environment, :databases
  
  def initialize
    @design_doc_name = 'cambric'
    @db_dir = './couchdb'
    @environment = 'development'
  end
  
end

