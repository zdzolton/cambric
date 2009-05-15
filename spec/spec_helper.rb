require 'spec'

# Gem dependencies... Here?
require 'rubygems'
gem 'jchris-couchrest'

require 'json'
require 'couchrest'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'cambric'

def load_fixture *path
  open(File.expand_path(File.join %w(spec fixtures) + path))
end

Spec::Runner.configure do |config|
  
end
