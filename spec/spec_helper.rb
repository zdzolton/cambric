require 'spec'

# Gem dependencies... Here?
require 'rubygems'
gem 'mattetti-couchrest'

require 'json'
require 'couchrest'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'cambric'

##############

TWITTER_CLONE_DATABASES = {
  :users => {
    :development => 'http://127.0.0.1:5984/users-development',
    :test => 'http://127.0.0.1:5984/users-testing'
  },
  :tweets => {
    :development => 'http://127.0.0.1:5984/tweets-development',
    :test => 'http://127.0.0.1:5984/tweets-testing'
  }
}

def configure_twitter_clone
  Cambric.configure do |config|
    config.design_doc_name = 'twitter-clone'
    config.db_dir = 'spec/fixtures/twitter-clone'
    config.environment = 'test'
    config.databases = TWITTER_CLONE_DATABASES
  end
end

def delete_twitter_clone_databases
  %w(users tweets).each{ |db| Cambric[db].delete! rescue nil }
end

#############

Spec::Runner.configure do |config|
  
end
