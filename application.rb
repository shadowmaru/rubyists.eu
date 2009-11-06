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
  session[:page] = 1
  session[:action] = :home
  
  @groups = Group.all(:order => [:created_at.desc], :limit => 10)
  
  haml :home
end

get '/about' do
  haml :about, :layout => false
end

get '/groups' do
  session[:page] = params[:page].to_i unless params[:page].nil?
  
  if request.xhr?
    Group.all.to_json(:exclude => [:location_id], :methods => [:location])
  else
    @groups = Group.all.page(session[:page], :per_page => 10)  
    haml :groups
  end
end

post '/groups' do
  if Location.first(:city => params[:city], :country_code => params[:country]).nil?
    location = Location.new(:city => params[:city], :country_code => params[:country])
    location.save
  end
  
  group = Group.new(:name => params[:name], :website => params[:website], :created_at => Time.new)
  group.location_id = Location.first(:city => params[:city], :country_code => params[:country]).id
  
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

get '/styles/:file' do
  response["Content-Type"] = "text/css; charset=utf-8"
  file = params[:file][0, params[:file].size - 4]

  sass file.to_sym, :views => File.join(File.dirname(__FILE__), 'public', 'styles')
end