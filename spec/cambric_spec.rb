require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'uri'

TWITTER_CLONE_DATABASES = {
  :users => {
    :development => 'http://127.0.0.1:5984/users-development',
    :test => 'http://127.0.0.1:5984/users-test'
  },
  :tweets => {
    :development => 'http://127.0.0.1:5984/tweets-development',
    :test => 'http://127.0.0.1:5984/tweets-test'
  }
}

describe Cambric do
  
  describe "after instantiating without a block" do
    before :all do
      @cambric = Cambric.new
    end
    
    it "should default its design doc name to 'cambric'" do
      @cambric.design_doc_name.should == 'cambric'
    end

    it "should default to './couchdb' for the database directory" do
      @cambric.db_dir.should == './couchdb'
    end
    
    it "should default to 'development' for the environment" do
      @cambric.environment.should == 'development'
    end
  end
  
  describe "after instantiating with a block" do
    before :all do
      @cambric = Cambric.new do |config|
        config.design_doc_name = 'twitter-clone'
        config.db_dir = '../to/some/path'
        config.environment = 'test'
        config.databases = TWITTER_CLONE_DATABASES
      end
    end
    
    it "should have the config object's value for the design doc name" do
      @cambric.design_doc_name.should == 'twitter-clone'
    end
    
    it "should have the config object's value for the database directory" do
      @cambric.db_dir.should == '../to/some/path'
    end    
    
    it "should have the config object's value for the environment" do
      @cambric.environment.should == 'test'
    end    
  end
  
  # describe "after initializing" do
  #   before :all do
  #     @cambric = Cambric.new 'twitter-clone'
  #   end
  #   
  #   it "should have the provided design doc name" do
  #     @cambric.design_doc_name.should == 'twitter-clone'
  #   end
  #   
  #   it "should default to './couchdb' for the database directory" do
  #     @cambric.db_dir.should == './couchdb'
  #   end
  #   
  #   it "should default to 'development' for the environment" do
  #     @cambric.environment.should == 'development'
  #   end
  # end
  # 
  # it "should not throw a fit when creating without setting databases" do
  #   Cambric.new('whatever').create_all_databases
  # end
  
  # describe "after creating databases" do
  #   before :all do
  #     @cambric = Cambric.new 'twitter-clone'
  #     @cambric.databases = TWITTER_CLONE_DATABASES
  #     @cambric.create_all_databases
  #   end
  #   
  #   it "should be able to query the expected databases" do
  #     %w(users tweets).each do |db|
  #       @cambric[db].info.should_not be_nil
  #     end
  #   end
  #   
  #   it "should have the expected URLs for the expected databases" do
  #     %w(users tweets).each do |db|
  #       @cambric[db].uri.should == "http://127.0.0.1:5984/#{db}-development"
  #     end
  #   end
  # end

end

describe Cambric::Configurator do
  before :all do
    @config = Cambric::Configurator.new
  end

  it "should default its design doc name to 'cambric'" do
    @config.design_doc_name.should == 'cambric'
  end

  it "should default to './couchdb' for the database directory" do
    @config.db_dir.should == './couchdb'
  end

  it "should default to 'development' for the environment" do
    @config.environment.should == 'development'
  end  
end
