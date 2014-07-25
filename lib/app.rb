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

end