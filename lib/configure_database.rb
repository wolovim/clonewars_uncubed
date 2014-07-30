class ConfigureDatabase
  def call
    connection = establish_connection
    create_tables_for(connection)
    connection
  end

  private

  def establish_connection
    if ENV['RUBY_ENV'] == "test"
      connection = Sequel.sqlite('test_database.db') #test_connection
    else
      connection = Sequel.sqlite('database.db') #test_connection
    end
  end

  def create_tables_for(connection)
    unless connection.table_exists? (:members)
      connection.create_table :members do
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

    unless connection.table_exists? (:member_types)
      connection.create_table :member_types do
        primary_key   :id
        string        :name
        integer       :total_seats
      end
    end

    unless connection.table_exists? (:reservations)
      connection.create_table :reservations do
        primary_key   :id
        string        :date
        integer       :hour
        integer       :minute
        string        :am_pm
        integer       :party_size
      end
    end

    unless connection.table_exists? (:events)
      connection.create_table :events do
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

    unless connection.table_exists? (:contents)
      connection.create_table :contents do
        primary_key :id
        string      :page
        string      :title
        string      :body
      end
    end
  end
end
