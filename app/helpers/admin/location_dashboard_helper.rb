module Admin::LocationDashboardHelper
  def event_url(e)
    "/admin/#{@location.url}/#{e.url}"
  end
end
