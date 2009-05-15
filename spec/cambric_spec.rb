require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "an instance of Cambric" do

  describe "when instantiating from a config file" do
    before :all do
      @cambric = Cambric.new(load_fixture 'tweets.yml')
    end

    it "should have something for config" do
      @cambric.config.should_not == nil
    end
  
    it "should contain a key for each database entry" do
      %w(users tweets).each do |db|
        @cambric.config.keys.should include(db)
      end
    end
  end

  describe "when already instantiated" do
    before :all do
      @cambric = Cambric.new(load_fixture 'foo-bar-baz.yml')
    end

    describe "when creating all databases for an environment" do
      before :all do
        @cambric.create_all_databases_for 'test'
      end
      
      it "should create a database for each name in cached hash keys config" do
        @cambric.config.keys.each do |db|
          CouchRest.new("localhost:5984/#{db}").info.should_not be_nil
        end
      end
    end
  end

end
