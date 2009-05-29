require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'uri'

TWITTER_CLONE_DATABASES = {
  :users => {
    :development => 'http://127.0.0.1:5984/users-development',
    :test => 'http://127.0.0.1:5984/users-testing'
  },
  :tweets => {
    :development => 'http://127.0.0.1:5984/tweets-development',
    :test => 'http://127.0.0.1:5984/tweets-testing'
  }
}

def configure_twitter_clone
  Cambric.configure do |config|
    config.design_doc_name = 'twitter-clone'
    config.db_dir = 'spec/fixtures/twitter-clone'
    config.environment = 'test'
    config.databases = TWITTER_CLONE_DATABASES
  end
end

def delete_twitter_clone_databases
  %w(users tweets).each{ |db| Cambric[db].delete! rescue nil }
end

describe Cambric do
  
  describe "after configuring without a block" do
    before :all do
      Cambric.configure
    end
    
    it "should default its design doc name to 'cambric'" do
      Cambric.design_doc_name.should == 'cambric'
    end

    it "should default to 'cambric' for the database directory" do
      Cambric.db_dir.should == 'cambric'
    end
    
    it "should default to 'development' for the environment" do
      Cambric.environment.should == 'development'
    end
    
    it "should not throw a fit when creating databases" do
      Cambric.create_databases
    end
  end
  
  describe "after instantiating with a block" do
    before :all do
      Cambric.configure do |config|
        config.design_doc_name = 'twitter-clone'
        config.db_dir = 'does/not/exist'
        config.environment = 'test'
        config.databases = TWITTER_CLONE_DATABASES
      end
    end
    
    it "should have the config object's value for the design doc name" do
      Cambric.design_doc_name.should == 'twitter-clone'
    end
    
    it "should have the config object's value for the database directory" do
      Cambric.db_dir.should == 'does/not/exist'
    end    
    
    it "should have the config object's value for the environment" do
      Cambric.environment.should == 'test'
    end
    
    it "should not blow up when calling push_design_docs for non-existent directories" do
      Cambric.push_design_docs
    end
  end
    
  describe "after creating databases" do
    before :all do
      configure_twitter_clone
      Cambric.create_databases
    end
    
    after(:all){ delete_twitter_clone_databases }
    
    it "should be able to query database info" do
      %w(users tweets).each do |db|
        Cambric[db].info.should_not be_nil
      end
    end
    
    it "should have the expected URLs" do
      %w(users tweets).each do |db|
        Cambric[db].uri.should == "http://127.0.0.1:5984/#{db}-testing"
      end
    end
    
    it "should have not yet pushed the design docs" do
      %w(users tweets).each do |db|
        lambda do
          Cambric[db].get("_design/twitter-clone")
        end.should raise_error(RestClient::ResourceNotFound)
      end
    end
  end
  
  describe "after pushing a test doc" do
    before :all do
      configure_twitter_clone
      Cambric.create_databases
      @test_doc = { 'foo' => 'bar' }
      Cambric[:tweets].save_doc @test_doc
    end
    
    after(:all){ delete_twitter_clone_databases }
    
    it "should not overwrite the database after calling create_databases" do
      Cambric.create_databases
      Cambric[:tweets].get(@test_doc['_id'])['foo'].should == 'bar'
    end
    
    it "should overwrite the database after calling create_databases!" do
      Cambric.create_databases!
      lambda do
        Cambric[:tweets].get(@test_doc['_id'])
      end.should raise_error(RestClient::ResourceNotFound)
    end
  end
  
  describe "after pushing design docs" do
    before :all do
      configure_twitter_clone
      Cambric.create_databases
      Cambric.push_design_docs
    end
    
    after(:all){ delete_twitter_clone_databases }
    
    it "should have defined views for design doc" do
      design_doc = Cambric[:tweets].get("_design/twitter-clone")
      design_doc['views']['by_follower_and_created_at'].should_not be_nil
    end
  
    it "should be able to query view without re-specifying design doc name" do
      Cambric[:tweets].view 'by_follower_and_created_at'
    end
  end
  
  describe "when the design doc already exists" do
    before :all do
      configure_twitter_clone
      Cambric.create_databases
      @design_doc = { '_id' => '_design/twitter-clone', 'foo' => 'bar' }
      Cambric[:tweets].save_doc @design_doc
    end
    
    after(:all){ delete_twitter_clone_databases }
    
    it "should overwrite when pushing design docs" do
      Cambric.push_design_docs
      Cambric[:tweets].get("_design/twitter-clone")['_rev'].should_not == @design_doc['_rev']
    end
  end
  
  describe "after calling prepare_databases" do
    before :all do
      configure_twitter_clone
      Cambric.prepare_databases
    end
    
    after(:all){ delete_twitter_clone_databases }
    
    it "should have created both databases" do
      %w(users tweets).each do |db|
        Cambric[db].info.should_not be_nil
      end
    end
    
    it "should have pushed the design doc to both databases" do
      %w(users tweets).each do |db|
        Cambric[db].get('_design/twitter-clone').should_not be_nil
      end
    end
    
    describe "calling prepare_databases again" do
      before :all do
        @test_doc = { 'foo' => 'bar' }
        Cambric[:tweets].save_doc @test_doc
        @design_doc_rev = Cambric[:tweets].get('_design/twitter-clone')['_rev']
        Cambric.prepare_databases
      end
      
      it "should not have re-created the database" do
        Cambric[:tweets].get(@test_doc['_id'])['foo'].should == 'bar'
      end
      
      it "should have updated the design doc" do
        Cambric[:tweets].get('_design/twitter-clone')['_rev'].should_not == @design_doc_rev
      end
    end
  end

end

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
        @dbs[db.to_sym].uri.should == "http://127.0.0.1:5984/#{db}-development"
      end
    end
  end
end
