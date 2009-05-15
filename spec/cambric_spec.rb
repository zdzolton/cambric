require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Cambric" do

  describe "when loading a config file" do
    
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

end
