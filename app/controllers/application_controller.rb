class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def current_user
    @current_user ||= User.find_by id: session[:user_id] if session[:user_id]
  end

  def authenticate_user!
    unless current_user
      flash[:danger] = "请先登录"
      redirect_to login_path
    end
  end

  def render_404
    render file: 'public/404.html', layout: false
  end
end
