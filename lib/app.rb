require 'bundler'
Bundler.require
require 'sequel'
require 'sqlite3'
require_relative 'models'
require 'pony'
require 'mail'
require 'contact'

class UncubedApp < Sinatra::Base
  set :method_override, true
  set :sessions => true
  set :root, "lib/app"
  get('/styles.css'){ scss :styles }

  configure :development do
    register Sinatra::Reloader
  end

  configure do
    enable :sessions
    set :username, 'admin'
    set :password, 'omg'
  end

  helpers do
    def admin?
      session[:admin]
    end
  end

  get '/' do
    erb :index
  end

  get '/login' do
    erb :login
  end

  get '/pricing' do
    erb :pricing
  end

  get '/gallery' do
    erb :gallery
  end

  get '/members' do
    members = Member.all
    erb :members, locals: {members: members}
  end

  get '/contact-us' do
    erb :contact_us
  end

  get '/social' do
    erb :social
  end

  get '/nearby' do
    erb :nearby
  end

  post '/login' do
    if params[:username] == settings.username && params[:password] == settings.password
      session[:admin] = true
      redirect to('/')
    else
      erb :login
    end
  end

  post '/members' do
    #add to the database
    # binding.pry
    Database.membership.insert(:first_name => params[:member][:first_name],
                   :last_name => params[:member][:last_name],
                   :email_address => params[:member][:email_address]
                  )
    redirect to('/members')
  end

  get '/logout' do
    session.clear
    redirect to('/')
  end

  post '/contact' do
    Email.new(params)
    redirect '/contact-us'
  end

  not_found do
    erb :error
  end
end
