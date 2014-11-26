class Admin::MonthlyReportDashboardController < Admin::AdminLocationController
  def index
    param_location = params[:location]
    param_year     = params[:year]
    param_month    = params[:month]

    @location = Location.find_by_url(param_location)
    @reports  = Report.where(location: @location).where(year: param_year).where(month: param_month)
    @report   = @reports.where(event: nil).first
    @people   = Person.where(location: @location).map{|x| x.name}
    records  = {}

    if @report != nil then
      for record in @report.records
        hash = record.person.name
        type = record.type.name
        name = hash

        if type != 'huge' && type != 'big' && type != 'medium' && type != 'small' then next end

        r = (records[hash] ||= [name, 0, 0, 0, 0, 0, 0])

        if type == 'huge' then r[1] += record.value.to_i end
        if type == 'big' then r[2] += record.value.to_i end
        if type == 'medium' then r[3] += record.value.to_i end
        if type == 'small' then r[4] += record.value.to_i end
        r[5] += record.value.to_i

        s = (type == 'huge' ? 2 : type == 'big' ? 1 : type == 'medium' ? 0.5 : type == 'small' ? 0.25 : 0)
        r[6] += record.value.to_i * s
      end
    end

    @records = records.map{|x| x[1]}
    @year    = param_year
    @month   = param_month
  end

  def save
    # get params
    param_location = params[:location]
    param_year     = params[:year]
    param_month    = params[:month]
    param_data     = params[:data]

    # fetch additional data
    records  = ActiveSupport::JSON.decode(param_data)
                   .select{|x| x[0] != nil}
    location = Location.find_by_url(param_location)

    # find or create report for specified
    # location and event
    report = Report.find_or_create_by(
        location: location,
        year: param_year,
        month: param_month,
        event: nil
    )

    report.records.destroy_all()

    # add records to report
    for record in records
      name     = record[0]
      person   = Person.find_or_create_by(name: name, location: location)
      huge     = RecordType.find_by_name('huge')
      big      = RecordType.find_by_name('big')
      medium   = RecordType.find_by_name('medium')
      small    = RecordType.find_by_name('small')

      Record.create(person: person, report:report, type: huge, value: record[1])
      Record.create(person: person, report:report, type: big, value: record[2])
      Record.create(person: person, report:report, type: medium, value: record[3])
      Record.create(person: person, report:report, type: small, value: record[4])
    end

    render json: {}
  end
end
