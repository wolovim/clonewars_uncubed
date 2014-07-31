require 'bundler'
Bundler.require
require 'sequel'
require 'sqlite3'
require_relative 'models'
require 'pony'
require 'mail'
require 'contact'
require 'pry'

class UncubedApp < Sinatra::Base # manages routes for application
  set :method_override, true
  set :sessions => true
  set :root, "lib/app"
  get('/styles.css'){ scss :styles }
  enable :sessions

  configure :development do
    set :session_secret, "something"
    register Sinatra::Reloader
  end

  configure do
    set :username, 'admin'
    set :password, 'omg'
  end

#############( INDEX )#############
  get '/' do
    content = Database.find_page_content('index')
    erb :index, locals: {content: content[:id]}
  end

##########( CONTENT MGMT )##########
  get '/add_content' do
    erb :add_content
  end

  post '/add_content' do
    Database.add_content(params[:content])
    redirect '/'
  end

  get '/pages/:page/edit' do |page|
    content = Database.find_page_content(page)
    erb :content_editor, locals: {content: content[:id]}
  end

  put '/pages/:page/edit' do |page|
    Database.edit_content(page, params[:content])
    redirect '/'
  end

##########( LOGIN/LOGOUT )##########
  helpers do
    def admin?
      session[:admin]
    end
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    if params[:username] == settings.username && params[:password] == settings.password
      session[:admin] = true
      redirect '/'
    else
      erb :login
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

###############( MEMBERS LOGIN) ##################
  helpers do
    def member?
      session[:admin]
    end
  end

  get '/member_login' do
    erb :member_login
  end

  post '/member_login' do
    if params[:username] == settings.username && params[:password] == settings.password
      session[:admin]    = true
      redirect '/event_form'
    else
      erb :member_login
    end
  end

  get '/member_logout' do
    session.clear
    redirect '/social'
  end

############( PRICING )############
  get '/pricing' do
    member_types = MemberType.all
    reservations = Reservation.all
    content      = Database.find_page_content('pricing')
    erb :pricing, locals: { member_types: member_types, reservations: reservations, content: content[:id] }
  end

  post '/pricing' do
    Database.membership_types.insert(:name => params[:types][:name], :total_seats => params[:types][:total_seats])
    redirect to('/pricing')
  end

  delete '/:id/reservation/delete' do |id|
    Database.delete_reservation(id)
    redirect to ('/pricing')
  end

  post '/reservation' do
    Database.reservations.insert(
                                 :date       => params[:reservations][:date],
                                 :hour       => params[:reservations][:hour],
                                 :minute     => params[:reservations][:minute],
                                 :am_pm      => params[:reservations][:am_pm],
                                 :party_size => params[:reservations][:party_size]
                                )
    redirect to('/pricing')
  end

##########( MEMBERSHIPS/MEMBERS )##########
  get '/members' do
    members            = Member.all
    member_types       = MemberType.all
    members_with_types = Database.members_with_types
    erb :members, locals: { members: members, member_types: member_types, members_with_types: members_with_types.to_a}
  end

  post '/members' do
    Database.add_member(params[:member])
    redirect to('/members')
  end

  get '/:id/edit' do |id|
    member = Database.find_member(id.to_i)
    erb :edit_member, locals: {member: member}
  end

  put '/:id/edit' do |id|
    Database.update_member(id.to_i, params[:member])
    redirect to('/members')
  end

  delete '/:id' do |id|
    Database.delete_event(id)
    redirect to('/social')
  end

############( GALLERY )###########
  get '/gallery' do
    erb :gallery
  end

##########( CONTACT US )##########
  get '/contact-us' do
    erb :contact_us
  end

  post '/contact' do
    Email.new(params)
    redirect '/contact-us'
  end

##########( SOCIAL/EVENTS )##########

  get '/social' do
    events = Event.all
    erb :social, locals: {events: events}
  end

  get '/event_login' do
    erb :event_login
  end

  get '/event_form' do
    erb :event_form
  end

  post '/social' do
    Database.events.insert(
                            :company  => params[:event][:company],
                            :title    => params[:event][:title],
                            :date     => params[:event][:date],
                            :time     => params[:event][:time],
                            :location => params[:event][:location],
                            :details  => params[:event][:details]
                          )
    redirect '/event_confirmation'
  end

  delete '/:id' do |id|
    Database.delete_member(id)
    redirect to('/members')
  end

  get '/event_confirmation' do
    erb :event_confirmation
  end

############( NEARBY )#############
  get '/nearby' do
    erb :nearby
  end

  not_found do
    erb :error
  end
end