require 'spec'

# Gem dependencies... Here?
require 'rubygems'
gem 'jchris-couchrest'

require 'json'
require 'couchrest'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'cambric'

Spec::Runner.configure do |config|
  
end
