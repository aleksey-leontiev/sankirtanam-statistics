class Admin::LocationDashboardController < Admin::AdminLocationController
  def index
    @sum    = {}
    @events = Event.all
    @year   = DateTime.now.year
    @months = ['', 'Январь', 'Февраль', 'Март', 'Апрель',
               'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь',
               'Октябрь', 'Ноябрь', 'Декабрь']
    lu      = @location.url
    @records = Record.includes(:report).includes(:report => :event).joins{ report }.joins{ report.location }.where{ report.location.url == lu }
    for record in @records
      hash = record.report.event == nil ?
          "#{record.report.year}:#{record.report.month}" :
          "event:#{record.report.event.url}"
      @sum[hash] ||= 0
      @sum[hash] += record.value.to_i
    end
  end
end
