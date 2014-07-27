require 'rubygems'
require 'sequel'

Sequel::Model.plugin(:schema)
DB = Sequel.sqlite('database.db')

unless DB.table_exists? (:members)
  DB.create_table :members do
    primary_key :id
    integer :membership_type_id
    string :first_name, :null => false
    string :last_name
    string :phone_number
    string :email_address
    string :company
    timestamp :joined_at
  end
end

class Member < Sequel::Model(:members)
  # Member Model
end
