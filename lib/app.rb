require 'bundler'
Bundler.require
require 'sequel'
require 'sqlite3'
require_relative 'models'
require 'pony'
require 'mail'
require 'contact'
require 'events'

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
    set    :username, 'admin'
    set    :password, 'omg'
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
    reservations = Reservation.all
    erb :pricing, locals: {member_types: member_types, reservations: reservations}
  end

  get '/gallery' do
    erb :gallery
  end

  get '/members' do
    members = Member.all
    member_types = MemberType.all
    members_with_types = Database.members_with_types
    erb :members, locals: {members: members, member_types: member_types, members_with_types: members_with_types.to_a}
  end

  get '/contact-us' do
    erb :contact_us
  end

  get '/nearby' do
    erb :nearby
  end

# ______________________________________________
  get '/social' do
    erb :social, locals: {events: EventStore.all.sort, event: Event.new(params)}
  end # ?????????????????Unsure about this method...vs the one below....

  get '/event_form' do
    erb :event_form
    # , locals: {events: EventStore.all.sort, event: Event.new(params)}
  end

  post '/social' do
    puts(params[:event].inspect)
    EventStore.create(Event.new(params[:idea]).to_h)
    redirect '/social'
  end
# _______________________________________________

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

  post '/reservation' do
    Database.reservations.insert(
                                 :date   => params[:reservations][:date],
                                 :hour   => params[:reservations][:hour],
                                 :minute => params[:reservations][:minute],
                                 :am_pm  => params[:reservations][:am_pm],
                                 :party_size => params[:reservations][:party_size]
                                )

    # reservations = Reservation.all
    # erb :pricing, locals: {reservations: reservations}
    redirect to('/pricing')
  end

  post '/members' do
    Database.add_member(params[:member])
    redirect to('/members')
  end

  get '/logout' do
    session.clear
    redirect to('/')
  end

  get '/:id/edit' do |id|
    member = Database.find_member(id.to_i)
    erb :edit_member, locals: {member: member}
  end

  put '/:id/edit' do |id|
    binding.pry
    Database.update_member(id.to_i, params[:member])
    redirect to('/members')
  end

  post '/contact' do
    Email.new(params)
    redirect '/contact-us'
  end

  delete '/:id' do |id|
    Database.delete_member(id)
    redirect to('/members')
  end

  not_found do
    erb :error
  end
end
