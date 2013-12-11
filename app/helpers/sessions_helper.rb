module SessionsHelper
  
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user #only needed when signin has no redirect
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    # ||= sets value ONLY if @current_user is undefined
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def current_user?(user)
    user == current_user
  end
  
  # used to be in users_controller.rb, but now also needed to check signin for 
  # Micropost actions, so moved to this sessions helper file
  def signed_in_user
    unless signed_in?
      store_location #record url of intended page before redirect
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  
  # this is called from sessions_controller.rb
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.url if request.get? # store url into session cookie
  end
  
  
  
end
