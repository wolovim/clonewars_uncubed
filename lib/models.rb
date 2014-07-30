require 'rubygems'
require 'sequel'
require_relative 'configure_database'

class DatabaseRepository
  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  def events
    connection[:events]
  end

  def events
    connection[:events]
  end

  def find_page_content(page)
    connection[:contents].where(:page => page)
  end

  def add_content(data)
    connection[:contents].insert(:page => data[:page],

  def find_page_content(page)
    connection[:contents].where(:page => page)
  end

  def add_content(data)
    connection[:contents].insert(:page => data[:page],

  def edit_content(page, data)
    connection[:contents].where(:page => page)
                  .update(:title => data[:title],
                          :body => data[:body]
                          )
  end

  def membership
    connection[:members]
  end

  def membership_types
    connection[:member_types]
  end

  def members_with_types
    connection[:member_types].join(:members, :membership_type_id => :id)
  end

  def reservations
    connection[:reservations]
  end

  def add_member(data)
    connection[:members].insert(:first_name => data[:first_name],
                   :last_name => data[:last_name],
                   :email_address => data[:email_address],
                   :phone_number => data[:phone_number],
                   :company => data[:company],
                   :membership_type_id => data[:membership_type_id],
                   :joined_at => Time.now)
  end

  def delete_member(id)
    connection[:members].where(:id => id).delete
  end

  def delete_reservation(id)
    connection[:reservations].where(:id => id).delete
  end

  def find_member(id)
    connection[:members].where(:id => id)
  end

  def update_member(id, data)
    connection[:members].where(:id => id)
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

connection = ConfigureDatabase.new.call
Database   = DatabaseRepository.new(connection)

require_relative 'models/members'
require_relative 'models/member_type'
require_relative 'models/content'
require_relative 'models/reservation'
