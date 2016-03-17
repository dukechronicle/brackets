class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_devise_params, if: :devise_controller?

  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      respond_to do |format|
        format.html do
          redirect_to :root
        end
        format.json do
          head :unauthorized
        end
      end
    end
  end

  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
