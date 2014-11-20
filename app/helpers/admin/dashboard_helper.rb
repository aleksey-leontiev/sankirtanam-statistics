module Admin::DashboardHelper
  def location_url(l)
    "/admin/#{l.url}"
  end
end
