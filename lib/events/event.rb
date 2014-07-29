class Event
  attr_reader :company, :title, :date, :time, :location, :details, :id

  def initialize(attributes = {})
    # binding.pry
    @company  = attributes["company"]
    @title    = attributes["title"]
    @date     = attributes["date"]
    @time     = attributes["time"]
    @location = attributes["location"]
    @details  = attributes["details"]
    @id       = attributes["id"]
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    {
      "company"  => company,
      "title"    => title,
      "date"     => date,
      "time"     => time,
      "location" => location,
      "details"  => details
    }
  end

  
end

# Company
# title
# date
# time
# location
# details