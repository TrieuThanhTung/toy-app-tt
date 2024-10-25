class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include SessionsHelper
  def facebook
    user = User.from_omniauth(request.env["omniauth.auth"])
    login_redirect(user, "Facebook")
  end

  def github
    user = User.from_github(auth)
    login_redirect(user, "Github")
  end

  def google_oauth2
    user = User.from_omniauth(auth)
    login_redirect(user, "Google")
  end

  def login_redirect(user, kind_sso)
    if user.persisted?
      log_in(user)
      flash[:notice] = t "devise.omniauth_callbacks.success", kind: kind_sso
      redirect_to user_url(user.id), event: :authentication
    else
      flash[:alert] = t "devise.omniauth_callbacks.failure", kind: kind_sso, reason: "#{auth.info.email} is not authorized."
      redirect_to login_path
    end
  end

  def auth
    @auth ||= request.env["omniauth.auth"]
  end

  def failure
    redirect_to root_path
  end
end
