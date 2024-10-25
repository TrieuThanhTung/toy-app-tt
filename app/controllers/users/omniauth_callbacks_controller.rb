class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
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
    # user = User.from_google(from_google_params)

    # if user.present?
    #   sign_out_all_scopes
    #   flash[:notice] = t "devise.omniauth_callbacks.success", kind: "Google"
    #   sign_in_and_redirect user, event: :authentication
    # else
    #   flash[:alert] = t "devise.omniauth_callbacks.failure", kind: "Google", reason: "#{auth.info.email} is not authorized."
    #   redirect_to new_user_session_path
    # end
    # #<OmniAuth::AuthHash::InfoHash email="21020799@vnu.edu.vn" email_verified=true first_name="21020799" image="https://lh3.googleusercontent.com/a/ACg8ocKVxM6SJ5Z6QQDO_-lISjk6FWbrX6WLlUNSrUOpuq3mt-OiJw=s96-c" last_name="Triệu Thanh Tùng" name="21020799 Triệu Thanh Tùng" unverified_email="21020799@vnu.edu.vn">

    logger.debug auth.info
    redirect_to root_path
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
