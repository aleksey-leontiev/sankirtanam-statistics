module Reports::EventReportHelper
  def location_nav_class(location)
    if @location == nil then return '' end
    @location.url == location.url ? 'active' : ''
  end
end
