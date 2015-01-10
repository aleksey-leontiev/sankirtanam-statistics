class Reports::OverallReportController < ApplicationController
  def index
    # get input parameters
    param_year     = params[:year]

    # output parameters
    data_table    = {}

    # fetch additional data
    records   = fetch_records(param_year)

    # process records
    for record in records
      #name   = record.person.name
      value  = record.value
      report = record.report
      #lc     = report.location
      lcn    = report.location.name
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

      row = (data_table[lcn] ||= empty_row(lcn))
      if type == "huge" then row[1]+=value.to_i end
      if type == "big" then row[2]+=value.to_i end
      if type == "medium" then row[3]+=value.to_i end
      if type == "small" then row[4]+=value.to_i end

      row[5] += value.to_i
      row[6] += value.to_i * (type == "huge" ? 2 : type == "big" ? 1 : type == "medium" ? 0.5 : type == "small" ? "0.25" : 0).to_f
    end

    # export data to view
    @location      = location
    @data_table    = data_table.map{ |x,y| y }
                         .sort{|x,y| x[6] <=> y[6] }
                         .reverse
  end

  private

  def fetch_records(year)
    query = Record
                .includes(:report)
                .joins { report }
                .joins { report.location }
                .where { report.year == year }
                .where { report.event_id == nil}
    query
  end

  def empty_row(location)
    [location, 0, 0, 0, 0, 0, 0]
  end
end
