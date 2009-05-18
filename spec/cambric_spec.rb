require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'uri'

describe Cambric do

  describe "when initializing without the design document name" do
    it "should raise an error" do
      lambda do 
        Cambric.new load_fixture('tweets.yml'), :environment => 'development' 
      end.should raise_error
    end
  end

  describe "when initializing for a non-specified environment" do
    it "should raise an error" do
      lambda do
        Cambric.new load_fixture('degenerate.yml'), 
                    :environment => 'staging', 
                    :design_doc => 'blarg'
      end.should raise_error
    end
  end
  
  it "should assume ./couchdb as the database path" do
    lambda do
      @cambric = Cambric.new load_fixture('foo-bar-baz.yml'), 
                             :environment => 'staging', 
                             :design_doc => 'xop'

      @cambric.push_all_design_docs
    end.should raise_error
  end

  describe "after initializing with required information" do
    before :all do
      @cambric = Cambric.new load_fixture('twitter-clone.yml'), 
                             :environment => 'development', 
                             :design_doc => 'twitter-clone',
                             :db_dir => File.join(FIXTURES_PATH, 'twitter-clone')
    end
  
    it "should have a value for the environment" do
      @cambric.environment.should_not be_nil
    end

    it "should have something for config" do
      @cambric.config.should_not be_nil
    end
    
    it "should match the given design document name" do
      @cambric.design_doc_name.should == 'twitter-clone'
    end
    
    it "should match the given database directory" do
      @cambric.db_dir.should =~ /\/spec\/fixtures\/twitter-clone/
    end

    it "should contain a key for each database entry" do
      %w(users tweets).each do |db|
        @cambric.config.keys.should include(db)
      end
    end
    
    it "should hash-style access databases, by name, as string or symbol" do
      %w(users tweets).each do |db_name|
        [db_name, db_name.to_sym].each do |db|
          @cambric[db].uri.should =~ /localhost:5984\/#{db}-development$/
        end
      end
    end
  end
    
  describe "when creating databases" do
    before :all do
      Cambric.new(load_fixture('foo-bar-baz.yml'), 
                  :environment => 'staging', 
                  :design_doc => 'xop',
                  :db_dir =>  File.join(FIXTURES_PATH, 'foo-bar-baz')).create_all_databases
      @server = CouchRest.new("localhost:5984")
    end
    
    it "should be able to access databases, with the environment name" do
      %w(bar baz).each do |db|
        @server.database("#{db}-staging").info.should_not be_nil
      end
    end
    
    it "should have pushed to each the specified design doc name" do
      %w(bar baz).each do |db|
        @server.database("#{db}-staging").get('_design/xop').should_not be_nil
      end
    end
  end
  
  describe "when the YAML specifies a host or port value" do
    before :all do
      @cambric = Cambric.new load_fixture('foo-bar-baz.yml'), 
                             :environment => 'somewhere', 
                             :design_doc => 'xop',
                             :db_dir =>  File.join(FIXTURES_PATH, 'foo-bar-baz')
    end
    
    it "should reflect the host value in the database URI" do
      URI.parse(@cambric[:bar].uri).host.should == 'some.where'
    end
    
    it "should reflect the port value in the database URI" do
      URI.parse(@cambric[:baz].uri).port.should == 5566
    end
  end

end
