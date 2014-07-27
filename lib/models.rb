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

  def self.membership
    DB[:members]
  end

  def self.membership_types
    DB[:member_types]
  end

  def self.members_with_types
    DB[:members].join(:member_types, :id => :membership_type_id)
  end
end

class Member < Sequel::Model(:members)
  # Member Model
end

class MemberType < Sequel::Model(:member_types)
  # MemberType Model
end
