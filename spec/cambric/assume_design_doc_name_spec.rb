require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Cambric::AssumeDesignDocName do
  describe "after pushing design docs" do
    
    before :all do
      configure_twitter_clone
      Cambric.prepare_databases!
    end
    
    after(:all){ delete_twitter_clone_databases }
    
    it "should be able to query view without re-specifying design doc name" do
      Cambric[:tweets].view :by_follower_and_created_at
    end
    
    it "should be able to specify design doc name when giving a string" do
      Cambric[:tweets].view 'twitter-clone/by_follower_and_created_at'
    end
    
    it "should get the design doc specified by configuration" do
      Cambric[:tweets].cambric_design_doc.should_not be_nil
    end
    
    describe "Casting documents from reduce=false query results" do
      before :all do
        Cambric[:tweets].save_doc 'author' => 'trevor', 'message' => "'sup, guys?", 'created_at' => '2009-06-06 11:52:34'
        class User < CouchRest::Document; end
        Cambric[:users].bulk_save [
          User.new('_id' => 'trevor', 'following' => %w(bob geoff scott brian zach), 'type' => 'User'),
          User.new('_id' => 'scott', 'following' => %w(bob geoff trevor brian zach), 'type' => 'User')
        ]
      end
      
      it "should cast to specified type, when cast_as is a type" do
        followers = Cambric[:users].get_docs_from_view :followers, :cast_as => User, 
                                                       :key => 'bob', :reduce => false
        followers.should have(2).elements
        followers.each{ |f| f.should be_a(User) }
      end
      
      it "should cast to type per-doc when cast_as is a string" do
        followers = Cambric[:users].get_docs_from_view :followers, :cast_as => 'type', 
                                                       :key => 'bob', :reduce => false
        followers.should have(2).elements
        followers.each{ |f| f.should be_a(User) }
      end
      
      it "should default to returning the plain doc hashes if cast_as is omitted" do
        followers = Cambric[:users].get_docs_from_view :followers, 
                                                       :key => 'bob', :reduce => false
        followers.should have(2).elements
        followers.each{ |f| f.should be_a(Hash) }
      end
    end
    
    describe "Casting documents from query results on a map-only view" do
      before :all do
        class Tweet < CouchRest::Document; end
        Cambric[:tweets].save_doc Tweet.new('author' => 'trevor', 'message' => "'sup, guys?", 'created_at' => '2009-06-06 11:52:34', 'followers' => %w(zach scott geoff))
      end
      
      it "should no longer put reduce=false into the query" do
        tweets = Cambric[:tweets].get_docs_from_view :by_follower_and_created_at, 
                                                     :limit => 1, :cast_as => Tweet
        tweets.first.should be_a(Tweet)
      end
    end
        
  end
end
