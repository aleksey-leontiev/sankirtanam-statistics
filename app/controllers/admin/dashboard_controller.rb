class Admin::DashboardController < Admin::AdminController
  def index
    cuid = current_user.id
    @access = UserLocationAccess.includes(:user).joins{user}.where{user.id == cuid}
    @locations = @access.map{|x| x.location}
  end
end
