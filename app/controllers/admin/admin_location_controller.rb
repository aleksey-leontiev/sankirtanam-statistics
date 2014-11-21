class Admin::AdminLocationController < Admin::AdminController
  before_action :fetch

  def fetch
    param_location = params[:location]

    @location      = Location.find_by_url(param_location)
    @user          = current_user

    render :html => "YOU HAVE NO RIGHTS HERE" if @location == nil
  end
end
