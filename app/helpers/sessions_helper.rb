module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:user_name] = user.name
  end

  def remember(user)
    user.remember
    cookies.encrypted[:user_id] = { value: user.id,
     expires: 1.years.from_now.utc }
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.encrypted[:user_id]
       user = User.find_by(id: cookies.encrypted[:user_id])
       if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        @current_user = user
       end
    end
  end

  def current_user?(user)
    current_user == user
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user) # why
    @current_user = nil
    reset_session
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
