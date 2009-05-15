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
      @cambric = Cambric.new(load_fixture 'foo-bar.yml')
    end

    describe "when creating all databases for an environment" do
      
      it "should create a database for each name in cached hash keys config" do
      end
      
    end
  end

end
