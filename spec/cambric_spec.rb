require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "an instance of Cambric" do

  describe "when instantiating from a config file" do
    
    describe "when not given the design document name" do
      it "should raise an error" do
        lambda{ Cambric.new load_fixture('tweets.yml'), :environment => 'development' }.should raise_error
      end
    end

    describe "for a non-specified environment" do
      it "should raise an error" do
        lambda do
          Cambric.new load_fixture('degenerate.yml'), :environment => 'staging', :design_doc => 'blarg'
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

    describe "for an environment specified in the YAML" do
      before :all do
        @cambric = Cambric.new load_fixture('twitter-clone.yml'), 
                               :environment => 'development', 
                               :design_doc => 'twitter-clone',
                               :db_dir => File.join(FXITURES_PATH, 'twitter-clone')
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
        @cambric.db_dir.should == './spec/fixtures/twitter-clone'
      end
  
      it "should contain a key for each database entry" do
        %w(users tweets).each do |db|
          @cambric.config.keys.should include(db)
        end
      end
      
      it "should access databases by name" do
        %w(users tweets).each do |db|
          @cambric[db].uri.should =~ /localhost:5984\/#{db}-development$/
        end
      end
    end
    
  end
  
  describe "when creating databases" do

    describe "for specified environment" do
      before :all do
        @cambric = Cambric.new load_fixture('foo-bar-baz.yml'), 
                               :environment => 'staging', 
                               :design_doc => 'xop',
                               :db_dir =>  File.join(FXITURES_PATH, 'foo-bar-baz')
        
        @cambric.create_all_databases
      end
      
      describe "for each name in cached hash keys config" do
        before :all do
          @bar = @cambric.config['bar']
        end
        
        it "should create a database" do
          @cambric.config.keys.each do |db|
            CouchRest.new("localhost:5984").database("#{db}-staging").info.should_not be_nil
          end
        end
        
        # it "should push the named design doc" do
        #   @cambric.config.keys.each do |db|
        #     CouchRest.new("localhost:5984").database("#{db}-staging").get('_design/xop').should_not be_nil
        #   end
        # end
      end
    end
    
  end

end
