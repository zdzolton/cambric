require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Cambric::AssumeDesignDocName do
  describe "after pushing design docs" do
    
    before :all do
      configure_twitter_clone
      Cambric.prepare_databases!
    end
    
    after(:all){ delete_twitter_clone_databases }
    
    it "should be able to query view without re-specifying design doc name" do
      Cambric[:tweets].view 'by_follower_and_created_at'
    end
    
    it "should get the design doc specified by configuration" do
      Cambric[:tweets].cambric_design_doc.should_not be_nil
    end
    
    describe "get_docs_from_view" do
      before :all do
        Cambric[:users].save_doc '_id' => 'trevor', 'following' => %w(bob geoff scott brian zach)
        Cambric[:users].save_doc '_id' => 'scott', 'following' => %w(bob geoff trevor brian zach)
      end
      
      it "should be able specify type to cast query result documents" do
        user_struct = Struct.new(:hash)
        followers = Cambric[:users].get_docs_from_view :followers, 
                                                       :cast_as => user_struct, 
                                                       :key => 'bob'
        followers.should have(2).elements
        followers.each{ |f| f.should be_a(user_struct) }
      end
    end
        
  end  
end
