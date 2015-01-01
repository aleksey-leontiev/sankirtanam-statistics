class Admin::EventDashboardController < Admin::AdminLocationController
  def index
    param_location = params[:location]
    param_event    = params[:event]

    @location = Location.find_by_url(param_location)
    @event    = Event.find_by_url(param_event)
    @report   = Report.where(location: @location).where(event: @event).first
    @people   = Person.where(location: @location).map{|x| x.name}
    records  = {}

    if @report != nil then
      for record in @report.records
        r = (records[record.person.name] ||= [record.person.name])

        if record.type.name == 'quantity' then r[record.day] = record.value end
        r[32] ||= 0
        r[33] ||= 0

        if record.type.name == 'quantity' then r[32] += (record.value or 0).to_i end
        if record.type.name == 'scores' then r[33] += (record.value or 0).to_i end
      end
    end

    @records = records.map{|x| x[1]}
  end

  def save
    # get params
    param_location = params[:location]
    param_event    = params[:event]
    param_data     = params[:data]

    # fetch additional data
    records  = ActiveSupport::JSON.decode(param_data)
                   .select{|x| x[0] != nil}
    location = Location.find_by_url(param_location)
    event    = Event.find_by_url(param_event)
    type     = RecordType.find_by_name('quantity')
    scores   = RecordType.find_by_name('scores')

    # find or create report for specified
    # location and event
    report = Report.find_or_create_by(
        location: location,
        event: event,
        year: event.start_date.year,
        month: event.start_date.month,
        day: event.start_date.day
    )

    report.records.destroy_all()

    # add records to report
    for record in records
      name     = record[0]
      person   = Person.find_or_create_by(name: name, location: location)

      for day in 1..31
        if record[day] == nil then next end
        Record.create(person: person, report:report, type: type, value: record[day], day:day)
      end

      Record.create(person: person, report: report, type: scores, value: record[33])
      #Record.create(report: report, )
    end

    render json: {}
  end
end
