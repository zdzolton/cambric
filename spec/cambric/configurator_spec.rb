require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Cambric::Configurator do
  before :all do
    @config = Cambric::Configurator.new
  end

  it "should default its design doc name to 'cambric'" do
    @config.design_doc_name.should == 'cambric'
  end

  it "should default to 'cambric' for the database directory" do
    @config.db_dir.should == 'cambric'
  end

  it "should default to 'development' for the environment" do
    @config.environment.should == 'development'
  end
  
  describe "when retrieving the configured CouchRest::Database instances" do
    before :all do
      @config.databases = TWITTER_CLONE_DATABASES
      @dbs = @config.initialize_databases
    end
    
    it "should have the expected URLs for development environment" do
      %w(users tweets).each do |db|
        @dbs[db.to_sym].uri.should == "/#{db}-development"
      end
    end
  end
end
