class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include SessionsHelper
  def facebook
    # @user = User.from_omniauth(request.env["omniauth.auth"])

    # if @user.persisted?
    #   sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
    #   set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    # else
    #   session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
    #   redirect_to new_user_registration_url
    # end

    logger.debug "log here -------------- #{auth} -----\n #{auth.info}"
    redirect_to root_path
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
    if user
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
