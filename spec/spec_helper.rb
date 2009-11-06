$LOAD_PATH << File.join(File.dirname(__FILE__), '..')

require 'application'
require 'spec'
require 'spec/interop/test'
require 'rack/test'

require 'spec/model_base_spec'

Test::Unit::TestCase.send :include, Rack::Test::Methods

set :environment, :test

def app
  Sinatra::Application
end