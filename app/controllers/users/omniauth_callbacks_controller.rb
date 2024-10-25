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

  def failure
    redirect_to root_path
  end

  def github
    # user = User.from_google(from_google_params)

    # if user.present?
    #   sign_out_all_scopes
    #   flash[:notice] = t "devise.omniauth_callbacks.success", kind: "Github"
    #   sign_in_and_redirect user, event: :authentication
    # else
    #   flash[:alert] = t "devise.omniauth_callbacks.failure", kind: "Github", reason: "#{auth.info.email} is not authorized."
    #   redirect_to new_user_session_path
    # end
    # <OmniAuth::AuthHash::InfoHash email=nil image="https://avatars.githubusercontent.com/u/109820897?v=4" name=nil nickname="TrieuThanhTung" urls=#<OmniAuth::AuthHash Blog="" GitHub="https://github.com/TrieuThanhTung">>
    logger.debug "log here -------------- #{auth.info} --- #{auth.info.nickname}"
    redirect_to root_path
   end

  def google_oauth2
    user = User.from_omniauth(auth)
    if user
      log_in(user)
      # remember(user) if params[:session][:remember_me] == "1"
      flash[:notice] = t "devise.omniauth_callbacks.success", kind: "Google"
      redirect_to user_url(user.id), event: :authentication
    else
      flash[:alert] = t "devise.omniauth_callbacks.failure", kind: "Google", reason: "#{auth.info.email} is not authorized."
      redirect_to login_path
    end
   end

   def from_google_params
     @from_google_params ||= {
       uid: auth.uid,
       email: auth.info.email
     }
   end

   def auth
     @auth ||= request.env["omniauth.auth"]
   end
end
