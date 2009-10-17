$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'sinatra'
require 'haml'
require 'sass'
#require 'openid'
#require 'openid/store/filesystem'
require 'json'
require 'rubyists'

DataMapper.setup :default, (ENV['DATABASE_URL'] || "postgres://postgres:postgres@localhost/rubyists")
# Don't auto-migrate anymore to prevent cleaning out the database.
# DataMapper.auto_migrate!
# Country.populate

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  set :sessions, true
end

get '/' do
  haml :home
end

get '/about' do
  haml :about, :layout => false
end

get '/groups' do
  haml :groups
end

get '/groups/new' do
  haml :group_form, :layout => false
end

post '/groups/new' do
  group = Group.new
  
  group.name = params[:name]
  group.city = params[:city]
  group.country = params[:country]
  group.website = params[:website]
  
  redirect '/'
end

get '/ajax/user_groups.js' do
  Group.all.to_json
end

get '/styles/:file' do
  response["Content-Type"] = "text/css; charset=utf-8"
  file = params[:file][0, params[:file].size - 4]

  sass file.to_sym, :views => File.join(File.dirname(__FILE__), 'public', 'styles')
end

#post '/login' do
#  session[:openid_consumer] = OpenID::Consumer.new(
#    session,
#    OpenID::Store::Filesystem.new( '/tmp/openid' )
#  )
#  oid_response = session[:openid_consumer].begin params['openid_url']
#  if oid_response
#    redirect oid_response.redirect_url(request.url, request.url + '/complete')
#  else
#    "failure"
#  end
#end
#
#get '/login/complete' do
#  if session[:openid_identity]
#    return 'wat'
#  end
#
#  oid_response = session[:openid_consumer].complete( params, request.url )
#  if oid_response.status != :success
#    return 'You are not logged in, your OpenID login failed or you refused to login'
#  end
#
#  if session[:openid_identity] = oid_response.identity_url
#    session.delete :openid_consumer
#    'You have successfully logged in as ' + session[:openid_identity]
#    redirect '/' # XXX
#  else
#    'please <a href="/login">Log In</a>'
#  end
#end
#
#post '/logout' do
#  if session[:openid_identity]
#    session.delete :openid_identity
#    'You have been logged out'
#    redirect '/' # XXX
#  else
#    'You were already logged out'
#  end
#end
#
#get '/check' do
#  if session[:openid_identity]
#    "you are logged in"
#  else
#    "please log in"
#  end
#end