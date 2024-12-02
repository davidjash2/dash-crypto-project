class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user  = User.find(session[:user_id])
    end
  end

  def log_in(user)
    session[:user_id] = user.id
    session[:private_key] = rand(2..Rails.application.config.p-2)
    session[:public_key] = (Rails.application.config.alpha ** session[:private_key]) % session[:private_key]
    puts("***We Are Cooking*****")
    puts(Rails.application.config.alpha)
    puts(session[:private_key])
    puts(session[:public_key])
    puts("***This is exciting****")
    @current_user = user
    redirect_to root_path
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
