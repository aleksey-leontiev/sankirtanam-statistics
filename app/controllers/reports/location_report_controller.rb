class Reports::LocationReportController < ApplicationController
  def index
    # get input parameters
    param_location = params[:location]
    param_year     = params[:year]

    # output parameters
    data_table    = {}

    # fetch additional data
    records   = fetch_records(param_location, param_year)

    # process records
    for record in records
      name   = record.person.name
      value  = record.value
      month  = record.report.month.to_i
      #report = record.report
      #lc     = report.location
      #lcn    = report.location.name
      type   = record.type.name
      #id     = param_location == nil ? "#{name} (#{lcn})" : "#{name}"
      #locations << lc if !locations.include?(lc)

      #r = (data_table[id] ||= empty_row(name, lcn))
      #if type == "quantity" then r[record.day+3] += record.value.to_i end
      #if type == "scores"   then r[2] += record.value.to_i end
      #if type == "quantity" then r[3] += record.value.to_i end

      #data_location[lcn] ||= 0
      #if type == "quantity" then data_location[lcn] += record.value.to_i end

      #data_person[id] ||= 0
      #if type == "quantity" then data_person[id] += record.value.to_i end

      row = (data_table[name] ||= empty_row(name))
      if type == "huge" then row[month]+=value.to_i end
      if type == "big" then row[month]+=value.to_i end
      if type == "medium" then row[month]+=value.to_i end
      if type == "small" then row[month]+=value.to_i end

      row[13] += value.to_i
      row[14] += value.to_i * (type == "huge" ? 2 : type == "big" ? 1 : type == "medium" ? 0.5 : type == "small" ? "0.25" : 0).to_f
    end

    # export data to view
    @location      = location
    @data_table    = data_table.map{ |x,y| y }
                         .sort{|x,y| x[14] <=> y[14] }
                         .reverse
  end

  private

  def fetch_records(location_url, year)
    query = Record
                .includes(:report)
                .includes(:person)
                .joins { report }
                .joins { report.location }
                .joins { person }
                .where { report.location.url == location_url }
                .where { report.year == year }
                .where { report.event_id == nil}
    query
  end

  def empty_row(name)
    [name, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0]
  end
end
