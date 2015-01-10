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
      value  = record.value
      report = record.report
      lcn    = report.location
      type   = record.type.name

      row = (data_table[lcn] ||= empty_row(lcn))
      if type == "huge" then row[1]+=value.to_i end
      if type == "big" then row[2]+=value.to_i end
      if type == "medium" then row[3]+=value.to_i end
      if type == "small" then row[4]+=value.to_i end

      row[5] += value.to_i
      row[6] += value.to_i * (type == "huge" ? 2 : type == "big" ? 1 : type == "medium" ? 0.5 : type == "small" ? "0.25" : 0).to_f
    end

    # export data to view
    @year          = param_year
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
    [location.name, 0, 0, 0, 0, 0, 0, location.url]
  end
end
