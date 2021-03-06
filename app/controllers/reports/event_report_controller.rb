class Reports::EventReportController < ApplicationController
  def index
    # get input parameters
    param_event    = params[:event]
    param_location = params[:location]

    # output parameters
    data_table    = {}
    data_location = {}
    data_person   = {}

    # fetch additional data
    event     = fetch_event(param_event)
    records   = fetch_records(param_event, param_location)
    locations = Location.all
    location  = Location.find_by_url(param_location)

    # process records
    for record in records
      name   = record.person.name
      report = record.report
      lc     = report.location
      lcn    = report.location.name
      type   = record.type.name
      id     = param_location == nil ? "#{name} (#{lcn})" : "#{name}"
      #locations << lc if !locations.include?(lc)

      r = (data_table[id] ||= empty_row(name, lcn))
      if type == "quantity" then r[record.day+3] += record.value.to_i end
      if type == "scores"   then r[2] += record.value.to_i end
      if type == "quantity" then r[3] += record.value.to_i end

      data_location[lcn] ||= 0
      if type == "quantity" then data_location[lcn] += record.value.to_i end

      data_person[id] ||= 0
      if type == "quantity" then data_person[id] += record.value.to_i end
    end

    # export data to view
    @event         = event
    @location      = location
    @locations     = locations
                         .sort{|x,y| x.name <=> y.name }
    @data_table    = data_table.map{ |x,y| y }
                         .sort{|x,y| x[2] <=> y[2] }
                         .reverse
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

  def fetch_records(event_url, location_url)
    query = Record
        .includes(:report)
        .includes(:person)
        .joins { report }
        .joins { report.event }
        .joins { report.location }
        .joins { person }
        .where { report.event.url == event_url }
    if location_url != nil
      query = query.where { report.location.url == location_url }
    end
    query
  end

  def empty_row(name, location)
    [name, location,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     0, 0, 0]
  end
end
