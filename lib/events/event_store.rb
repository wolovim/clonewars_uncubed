require "yaml/store"

class EventStore

  def self.create(attributes)
    event = Event.create(attributes)
    database.transaction do 
      database["events"] << event.to_h
    end
  end

  def self.database
    return @database if @database
  end

    @database = YAML::Store.new("db/events")
    @database.transaction do
      @database["events"] ||= []
    end
    @database
  end

  def self.all
    events = []
    raw_events.each_with_index do |data, e|
      events << Event.new(data.merge("id" => e))
    end
    events
  end

  def self.raw_events
    database.transaction do |db|
      db["events"] || []
  end
end