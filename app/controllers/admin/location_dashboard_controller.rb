class Admin::LocationDashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    param_location = params[:location]

    @location      = Location.find_by_url(param_location)
    @events        = Event.all
  end
end
