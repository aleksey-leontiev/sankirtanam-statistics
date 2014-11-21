class Admin::DashboardController < Admin::AdminController
  def index
    @access = UserLocationAccess.includes(:user).where(user = current_user)
    @locations = @access.map{|x| x.location}
  end
end
