module Cambric
    
  # This class has been reimplemented to main my original usage of its interface,
  # but hook it up to Python couchapp so I have fewer maintenance headaches...
  class FileManager

    def initialize dbname, host="http://127.0.0.1:5984"
      @dbname = dbname
      @host = host
    end

    # maintain the correspondence between an fs and couch

    def push_app path, ddoc_name
      dest = "#{@host}/#{@dbname}"
      ddoc_id = "_design/#{ddoc_name}"
      %x[ couchapp push -q --docid #{ddoc_id} #{path} '#{dest}' ]
    end

  end
end
