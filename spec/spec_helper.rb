require File.join(File.dirname(__FILE__), '..', 'application')

require 'spec'
require 'rack/test'
require 'spec/interop/test'

Test::Unit::TestCase.send :include, Rack::Test::Methods

set :environment, :test

def app
  Sinatra::Application
end