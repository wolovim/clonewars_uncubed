require 'rubygems'
require 'sequel'

class Database
  attr_reader :connection
  # Sequel::Model.plugin(:schema)
  # DB = Sequel.sqlite('database.db')

  # def initialize
  if ENV['RUBY_ENV'] == "test"
    @connection = Sequel.sqlite('test_database.db') #test_connection
  else
    @connection = production_connection
  end
  # end

  def self.production_connection
    puts "Setting up PRODUCTION environment database..."
    Sequel.sqlite('database.db')
  end

  def test_connection
    puts "Setting up TEST environment database..."
    Sequel.sqlite('test_database.db')
  end

  unless @connection.table_exists? (:members)
    @connection.create_table :members do
      primary_key   :id
      integer       :membership_type_id
      string        :first_name, :null => false
      string        :last_name
      string        :phone_number
      string        :email_address
      string        :company
      timestamp     :joined_at
    end
  end

  unless @connection.table_exists? (:member_types)
    @connection.create_table :member_types do
      primary_key   :id
      string        :name
      integer       :total_seats
    end
  end

  unless @connection.table_exists? (:reservations)
    @connection.create_table :reservations do
      primary_key   :id
      string        :date
      integer       :hour
      integer       :minute
      string        :am_pm
      integer       :party_size
    end
  end

  unless @connection.table_exists? (:events)
    @connection.create_table :events do
      primary_key   :id
      string        :company
      string        :title
      string        :date
      integer       :time
      string        :am_pm
      string        :location
      string        :details
    end
  end

  def self.events
    @connection[:events]
  end

  unless @connection.table_exists? (:contents)
    @connection.create_table :contents do
      primary_key :id
      string      :page
      string      :title
      string      :body
    end
  end

  def self.find_page_content(page)
    @connection[:contents].where(:page => page)
  end

  def self.add_content(data)
    @connection[:contents].insert(:page => data[:page],
                    :title => data[:title],
                    :body => data[:body]
                    )
  end

  def self.edit_content(page, data)
    @connection[:contents].where(:page => page)
                  .update(:title => data[:title],
                          :body => data[:body]
                          )
  end

  def self.membership
    @connection[:members]
  end

  def self.membership_types
    @connection[:member_types]
  end

  def self.members_with_types
    @connection[:member_types].join(:members, :membership_type_id => :id)
  end

  def self.reservations
    @connection[:reservations]
  end

  def self.add_member(data)
    @connection[:members].insert(:first_name => data[:first_name],
                   :last_name => data[:last_name],
                   :email_address => data[:email_address],
                   :phone_number => data[:phone_number],
                   :company => data[:company],
                   :membership_type_id => data[:membership_type_id],
                   :joined_at => Time.now)
  end

  def self.delete_member(id)
    @connection[:members].where(:id => id).delete
  end

  def self.delete_reservation(id)
    @connection[:reservations].where(:id => id).delete
  end

  def self.find_member(id)
    @connection[:members].where(:id => id)
  end

  def self.update_member(id, data)
    @connection[:members].where(:id => id)
        .update(:company => data[:company],
                :membership_type_id => data[:membership_type_id],
                :first_name => data[:first_name],
                :last_name => data[:last_name],
                :email_address => data[:email_address],
                :joined_at => data[:joined_at],
                :id => data[:id]
                )
  end
end

class Event < Sequel::Model(:events)
  # Event Model
end

class Member < Sequel::Model(:members)
  # Member Model
end

class MemberType < Sequel::Model(:member_types)
  # MemberType Model
end

class Reservation < Sequel::Model(:reservations)
  #Reservation Model
end

class Content < Sequel::Model(:contents)
  #Content Model
end
