require "bundler"
Bundler.require

class UncubedApp < Sinatra::Base
  set :method_override, true
  set :root, "lib/app"

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    erb :error
  end

  get '/' do
    erb :index
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
end