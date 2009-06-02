require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Cambric::TestHelpers do
  
  include Cambric::TestHelpers
  
  before :all do
    configure_twitter_clone
    Cambric.prepare_databases!
  end
  
  after(:all){ delete_twitter_clone_databases }
  
  describe "testing a view's map function" do
    it "should return an array, with an element for each call to emit()" do
      kv_pairs = execute_map :users, :followers,
                             '_id' => 'poddle', 'following' => ['jack', 'russel']
      kv_pairs.size.should == 2
      kv_pairs[0]['key'].should == 'jack'
      kv_pairs[1]['key'].should == 'russel'
      kv_pairs[0]['value'].should == 'poddle'
      kv_pairs[1]['value'].should == 'poddle'
    end
    
    it "should skip any documents that throw an error"
  end
  
  describe "testing a view's reduce function" do
    
    it "passed in keys...?"
    it "passed in values...?"
    it "should default to false for rereduce"
    
  end

end
