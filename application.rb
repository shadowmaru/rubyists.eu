$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'sinatra'
require 'rubyists'
require 'haml'
require 'sass'
require 'json'

configure do
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :sessions, true
end

get '/' do
  @groups = Group.all(:order => [:created_at.desc], :limit => 10)

  haml :home
end

get '/about' do
  haml :about, :layout => false
end

get '/groups' do
  @groups = Group.all(:order => [:country_code.asc, :city.asc])
  
  request.xhr? ? @groups.to_json :
                 haml(:groups)
end

post '/groups' do
  group = Group.new

  group.name = params[:name]
  group.city = params[:city]
  group.country_code = params[:country]
  group.website = params[:website]
  group.created_at = Time.new 
  
  group.save
  
  redirect '/groups'
end

delete '/groups/:id' do
  group = Group.get(params[:id])
  
  group.destroy
end

get '/groups/new' do
  @countries = Country.all(:order => [:name.asc])
  
  haml :group_form, :layout => false
end

get '/countries/:code' do
  Country.get(params[:code]).to_json
end

get '/styles/:file' do
  response["Content-Type"] = "text/css; charset=utf-8"
  file = params[:file][0, params[:file].size - 4]

  sass file.to_sym, :views => File.join(File.dirname(__FILE__), 'public', 'styles')
end