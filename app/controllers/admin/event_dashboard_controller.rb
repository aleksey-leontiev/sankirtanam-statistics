class Admin::EventDashboardController < ApplicationController
  def index
    param_location = params[:location]
    param_event    = params[:event]

    @location = Location.find_by_url(param_location)
    @event    = Event.find_by_url(param_event)
  end
end
