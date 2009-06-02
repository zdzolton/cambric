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
    
    it "should return an empty array when documents cause an exception" do
      kv_pairs = execute_map :users, :bad, "doesn't" => 'matter'
      kv_pairs.length.should == 1
    end
  end
  
  describe "testing a view's reduce function" do
    
    it "should default to false for rereduce" do
      result = execute_reduce :users, :followers, :values => ['dr', 'quinn', 'medicine', 'woman']
      result.should == 4
    end
    
    it "should be able to execute a rereduce" do
      result = execute_reduce :users, :followers, :values => [4, 5, 6], :rereduce => true
      result.should == 15 
    end
    
    it "should forward exceptions to Ruby" do
      lambda do
        execute_reduce :users, :bad, :values => ['what', 'ever']
      end.should raise_error(Cambric::TestHelpers::ReduceError)
    end
    
  end

end
