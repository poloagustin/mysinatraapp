require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require 'slim'
require './song'
require 'bundler/setup'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

get('/styles.css'){ scss :styles }

get '/' do
  slim :home
  # erb :home
end

get '/about' do
  @title = "All About This WebSite"
  slim :about
end
get '/contact' do
  slim :contact
  # erb :contact
end

get '/set/:name' do
  session[:name] = params[:name]
end

get '/get/hello' do
  "Hello #{session[:name]}"
end

get '/login' do
  slim :login
  # erb :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/songs')
  else
    slim :login
    # erb :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end
