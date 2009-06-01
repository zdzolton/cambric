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
  end
  
end
