class ConfigureDatabase # sets up database for application on launch
  def call
    connection = establish_connection
    create_tables_for(connection)
    connection
  end

  private

  def establish_connection
    if ENV['RUBY_ENV'] == "prod"
      connection = Sequel.sqlite('database.db')
    else
      connection = Sequel.sqlite('test_database.db')
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
      connection[:member_types].insert(:name => "Open Desk", :total_seats => 38)
      connection[:member_types].insert(:name => "Designated Desk", :total_seats => 32)
      connection[:member_types].insert(:name => "Designated Suite", :total_seats => 26)
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

Pricing.new.connection 
      connection[:contents].insert(:page => "pricing",
                                   :title => "Pricing",
                                   :body => "<div>
                                              <p>&nbsp;</p>
                                              <div><b>OPEN DESK MEMBERSHIP</b></div>
                                                <div>
                                                  <ul>
                                                    <li>Mon-Fri / 730-530 keycard access</li>
                                                    <li>use any available open area desk</li>
                                                    <li>each seat has monitor available</li>
                                                    <li>conference room usage: not included</li>
                                                    <li>phone booth usage: full</li>
                                                    <li>kitchen access: full</li>
                                                    <li>$150/month per member</li>
                                                    <li><strong>SOLD OUT</strong> (contact us to be on waiting list)</li>
                                                  </ul>
                                                  <p>&nbsp;</p>
                                                </div>
                                                <div></div>
                                                <div></div>
                                                <div><b>DESIGNATED DESK MEMBERSHIP</b></div>
                                                <div>
                                                  <ul>
                                                  <li>365/24/7 keycard access</li>
                                                  <li>dedicated desk for your use only</li>
                                                  <li>GeekDesk (adjustable for sitting or standing) provided</li>
                                                  <li>conference room usage: limited</li>
                                                  <li>phone booth usage: full</li>
                                                  <li>kitchen access: full</li>
                                                  <li>$395/month</li>
                                                  <li><strong>SOLD OUT</strong> (contact us to be on waiting list)</li>
                                                  </ul>
                                                  <p>&nbsp;</p>
                                                    <div>
                                                      <div></div>
                                                      <div></div>
                                                      <div><b>DESIGNATED SUITE MEMBERSHIP</b></div>
                                                        <div>
                                                          <ul>
                                                          <li>365/24/7 keycard access</li>
                                                          <li>dedicated suite for your use only</li>
                                                          <li>conference room usage: full</li>
                                                          <li>phone booth usage: full</li>
                                                          <li>kitchen access: full</li>
                                                          <li><strong>SOLD OUT</strong> (contact us to be on waiting list)</li>
                                                          </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                              </div>"
                                   )
      connection[:contents].insert(:page => "index",
                                   :title => "Coworking for the Entrepreneurial Kind",
                                   :body => "<p>Uncubed is a Denver coworking community for entrepreneurial types, from freelancers to single co-founders to small startups. Based in Denver&#8217;s LoDo district, our collaborative environment works similar to an incubator&#8211;a collection of creative minds exchanging ideas and insights with one another in a common space.</p>
                                             <p>Uncubed is the answer for those who are looking to escape the home office, the kitchen table, or the noisy realm of the coffee shop. With our tech-friendly environment and reliable, high-speed wireless internet, we aim to be a haven for those who work and create in the tech and creative fields.</p>
                                             <p>We also host various meetups and workshops throughout the week for networking and educational opportunities. In short, everything we do is true to our mission: to use collaborative coworking as a tool to develop Denver&#8217;s entrepreneurial scene into a thriving hub of opportunity.</p>
                                             <p>Uncube yourself and cowork different. Come check us out!</p>
                                             <p><a href='http://www.uncubedspace.com/cont act-us/' title='Contact Us'>Contact Us</a> to schedule a tour!</p>"
                                   )
    end
  end
end
