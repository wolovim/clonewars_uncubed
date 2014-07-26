require "bundler"
Bundler.require

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
    erb :members
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

  get '/logout' do
    session.clear
    redirect to('/')
  end

  not_found do
    erb :error
  end
end
