require 'rubygems'
require 'sequel'

class Database
  Sequel::Model.plugin(:schema)
  DB = Sequel.sqlite('database.db')

  unless DB.table_exists? (:members)
    DB.create_table :members do
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

  unless DB.table_exists? (:member_types)
    DB.create_table :member_types do
      primary_key   :id
      string        :name
      integer       :total_seats
    end
  end

  unless DB.table_exists? (:reservations)
    DB.create_table :reservations do
      primary_key   :id
      string        :date
      integer       :hour
      integer       :minute
      string        :am_pm
      integer       :party_size
    end
  end

  unless DB.table_exists? (:events)
    DB.create_table :events do
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
    DB[:events]
  end

  unless DB.table_exists? (:contents)
    DB.create_table :contents do
      primary_key :id
      string      :title
      string      :body
    end
  end

  def self.membership
    DB[:members]
  end

  def self.membership_types
    DB[:member_types]
  end

  def self.members_with_types
    DB[:member_types].join(:members, :membership_type_id => :id)
  end

  def self.reservations
    DB[:reservations]
  end

  def self.add_member(data)
    DB[:members].insert(:first_name => data[:first_name],
                   :last_name => data[:last_name],
                   :email_address => data[:email_address],
                   :phone_number => data[:phone_number],
                   :company => data[:company],
                   :membership_type_id => data[:membership_type_id],
                   :joined_at => Time.now)
  end

  def self.delete_member(id)
    DB[:members].where(:id => id).delete
  end

  def self.delete_reservation(id)
    DB[:reservations].where(:id => id).delete
  end

  def self.find_member(id)
    DB[:members].where(:id => id)
  end

  def self.update_member(id, data)
    DB[:members].where(:id => id)
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
