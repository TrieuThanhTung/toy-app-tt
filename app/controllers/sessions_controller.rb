class SessionsController < ApplicationController
  include SessionsHelper
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])
    #   redirect_to user
    # else
    #   flash.now[:danger] = "Invalid email/password combination login"
    #   render "new"
    # end

    respond_to do |format|
      if user&.valid_password?(params[:session][:password])
        if user.activated?
          reset_session
          log_in(user)
          remember(user) if params[:session][:remember_me] == "1"
          format.html { redirect_to user_url(user.id) || user, notice: "Login success." }
        else
          message = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:warning] = message
          format.html { redirect_to root_url || user, notice: "Login success." }
        end
      else
        flash.now[:danger] = "Invalid email/password combination login"
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private
  def get_email
    params.require(:session).permit(:email)
  end
end
