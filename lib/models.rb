require 'rubygems'
require 'sequel'
require_relative 'configure_database'

class DatabaseRepository # holds methods for database interactions
  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  ########( CONTENTS )########
  def contents
    connection[:contents]
  end

  def find_page_content(page)
    contents.where(:page => page)
  end

  def find_page_content(page)
    contents.where(:page => page)
  end

  def add_content(data)
    contents.insert(:page  => data[:page],
                    :title => data[:title],
                    :body  => data[:body]
                    )
  end

  def edit_content(page, data)
    contents.where(:page => page).update(:title  => data[:title],
                                         :body   => data[:body]
                                         )
  end

  ########( EVENTS )########
  def events
    connection[:events]
  end

  def add_event(data)
    events.insert(:company  => data[:company],
               :title       => data[:title],
               :date        => data[:date],
               :time        => data[:time],
               :location    => data[:location],
               :details     => data[:details]
               )
  end

  def delete_event(id)
    events.where(:id => id).delete
  end

  ########( MEMBERS )########
  def membership
    connection[:members]
  end

  def find_member(id)
    membership.where(:id => id)
  end

  def add_member(data)
    membership.insert(:first_name      => data[:first_name],
                   :last_name          => data[:last_name],
                   :email_address      => data[:email_address],
                   :phone_number       => data[:phone_number],
                   :company            => data[:company],
                   :membership_type_id => data[:membership_type_id],
                   :joined_at          => Time.now
                   )
  end

  def update_member(id, data)
    membership.where(:id  => id)
        .update(:company            => data[:company],
                :membership_type_id => data[:membership_type_id],
                :first_name         => data[:first_name],
                :last_name          => data[:last_name],
                :email_address      => data[:email_address],
                :joined_at          => data[:joined_at],
                :id                 => data[:id]
                )
  end

  def delete_member(id)
    membership.where(:id => id).delete
  end

  ########( MEMBER TYPES )########
  def membership_types
    connection[:member_types]
  end

  def members_with_types
    membership_types.join(:members, :membership_type_id => :id)
  end

  ########( RESERVATIONS )########
  def reservations
    connection[:reservations]
  end

  def add_reservation(data)
    reservations.insert(:date   => data[:date],
                    :hour       => data[:hour],
                    :minute     => data[:minute],
                    :am_pm      => data[:am_pm],
                    :party_size => data[:party_size]
                    )
  end

  def delete_reservation(id)
    reservations.where(:id => id).delete
  end
end

connection = ConfigureDatabase.new.call
Database   = DatabaseRepository.new(connection)

require_relative 'models/member'
require_relative 'models/event'
require_relative 'models/reservation'
require_relative 'models/member_type'
require_relative 'models/content'
require_relative 'models/reservation'
