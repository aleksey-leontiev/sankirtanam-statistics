module Admin::LocationDashboardHelper
  def event_url(e)
    "/admin/#{@location.url}/#{e.url}"
  end

  def monthly_report_url(year, month)
    "/admin/#{@location.url}/#{year}/#{month}"
  end
end
