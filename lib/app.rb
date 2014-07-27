require "bundler"
Bundler.require
require 'sequel'
require 'sqlite3'
require_relative 'models'

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
    member_types = MemberType.all
    erb :pricing, locals: {member_types: member_types}
  end

  get '/gallery' do
    erb :gallery
  end

  get '/members' do
    members = Member.all
    member_types = MemberType.all
    members_with_types = Database.members_with_types
    erb :members, locals: {members: members, member_types: member_types, members_with_types: members_with_types}
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

  post '/pricing' do
    Database.membership_types.insert(:name => params[:types][:name],
                                     :total_seats => params[:types][:total_seats]
                                    )
    redirect to('/pricing')
  end

  post '/members' do
    Database.membership.insert(:first_name => params[:member][:first_name],
                   :last_name => params[:member][:last_name],
                   :email_address => params[:member][:email_address],
                   :phone_number => params[:member][:phone_number],
                   :company => params[:member][:company],
                   :membership_type_id => params[:member][:membership_type_id],
                   :joined_at => Time.now
                  )
    redirect to('/members')
  end

  get '/logout' do
    session.clear
    redirect to('/')
  end

  post '/contact_us' do
    require 'pony'
      Pony.mail(
        :from => params[:name] + "<" + params[:email] + ">",
        :to => 'clonewars.uncubed@gmail.com',
        :subject => params[:name] + " has contacted you",
        :body => params[:message],
        :port => '587',
        :via => :smtp,
        :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'daz',
          :password             => 'p@55w0rd',
          :authentication       => :plain,
          :domain               => 'localhost.localdomain'
        })
      redirect '/success'
  end

  get('/success'){"Thanks for your email. We will be in touch."}

  delete '/:id' do |id|
    Database.membership.where(:id => id).delete
    redirect to('/members')
  end

  not_found do
    erb :error
  end
end
