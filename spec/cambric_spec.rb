require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "an instance of Cambric" do

  describe "when instantiating from a config file" do
    before :all do
      @cambric = Cambric.new load_fixture('tweets.yml'), 'development'
    end
    
    it "should have a value for the environment" do
      @cambric.environment.should_not be_nil
    end

    it "should have something for config" do
      @cambric.config.should_not be_nil
    end
  
    it "should contain a key for each database entry" do
      %w(users tweets).each do |db|
        @cambric.config.keys.should include(db)
      end
    end
  end

  describe "when creating databases" do

    describe "for specified environment" do
      before :all do
        @cambric = Cambric.new load_fixture('foo-bar-baz.yml'), 'staging'
        @cambric.create_all_databases_for 'staging'
      end
      
      describe "for each name in cached hash keys config" do
        before :all do
          @bar = @cambric.config['bar']
        end
        
        it "should create a database" do
          @cambric.config.keys.each do |db|
            CouchRest.new("localhost:5984/#{db}-staging").info.should_not be_nil
          end
        end
        
        # it "should push a design doc for each directory" do
        # end
      end
    end

    describe "for a non-specified environment" do
      before :all do
        @cambric = Cambric.new load_fixture('degenerate.yml'), 'staging'
      end
    
      it "should raise an error" do
        lambda{ @cambric.create_all_databases_for 'staging' }.should raise_error
      end
    end
    
  end

end
