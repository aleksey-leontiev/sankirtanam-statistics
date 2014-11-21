class Admin::LocationDashboardController < Admin::AdminLocationController
  def index
    @events = Event.all
  end
end
