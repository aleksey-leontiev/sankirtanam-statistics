class Admin::DashboardController < ApplicationController
  def index
    @locations = Location.all
  end
end
