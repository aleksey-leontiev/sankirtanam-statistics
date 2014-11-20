class Admin::LocationDashboardController < ApplicationController
  def index
    param_location = params[:location]

    @location      = Location.find_by_url(param_location)
    @events        = Event.all
  end
end
