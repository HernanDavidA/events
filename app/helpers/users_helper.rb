module UsersHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  def admin_user?
    current_user&.is_admin?
  end
end
