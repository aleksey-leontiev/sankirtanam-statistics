module Admin::MonthlyReportDashboardHelper
  def other_report_url(report)
    report.event != nil ?
        "/admin/#{@location.url}/#{report.event.url}" :
        "/admin/#{@location.url}/#{report.year}/#{report.month}"
  end

  def other_report_name(report)
    report.event != nil ?
        report.event.name :
        "#{report.month}-#{report.year}"
  end
end
