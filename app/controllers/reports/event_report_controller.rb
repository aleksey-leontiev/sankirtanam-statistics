class Reports::EventReportController < ApplicationController
  def index
    # get input parameters
    param_event = params[:event]

    # output parameters
    data_table = {}
    data_location = {}
    data_person = {}

    # fetch additional data
    event   = fetch_event(param_event)
    records = fetch_records(param_event)

    # process records
    for record in records
      name     = record.person.name
      location = record.report.location.name
      id     = "#{name} (#{location})"

      r = (data_table[id] ||= empty_row(name, location))
      r[record.day+1] += record.value.to_i
      r[33] += record.value.to_i

      data_location[location] ||= 0
      data_location[location] += record.value.to_i

      data_person[id] ||= 0
      data_person[id] += record.value.to_i
    end

    # export data to view
    @event         = event
    @data_table    = data_table.map{ |x,y| y }
    @data_location = data_location.map{ |x,y| [x,y] }
                         .sort{|x,y| x[1] <=> y[1]}
                         .reverse
    @data_person   = data_person
                         .map{|x,y| [x,y]}
                         .sort{|x,y| x[1] <=> y[1]}
                         .reverse[0..15]
  end

  private

  def fetch_event(event_url)
    Event.find_by_url(event_url)
  end

  def fetch_records(event_url)
    Record
        .includes(:report)
        .includes(:person)
        .joins { report }
        .joins { report.event }
        .joins { person }
        .where { report.event.url == event_url }
  end

  def empty_row(name, location)
    [name, location,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0]
  end
end
