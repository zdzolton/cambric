module Cambric
  class Configurator
  
    attr_accessor :design_doc_name, :db_dir, :environment, :databases
  
    def initialize
      @design_doc_name = 'cambric'
      @db_dir = 'cambric'
      @environment = 'development'
      @databases = {}
    end
  
    def initialize_databases
      dbs_by_name = {}
      @databases.each_pair do |db,urls_by_env|
        urls_by_env.keys.map!{ |env| env.to_sym }
        dbs_by_name[db.to_sym] = initialize_database(urls_by_env[@environment.to_sym])
      end
      dbs_by_name
    end
  
  private

    def initialize_database url
      database = CouchRest.database url
      database.extend ::Cambric::AssumeDesignDocName
      database.cambric_design_doc_name = @design_doc_name
      database
    end
  
  end
end
