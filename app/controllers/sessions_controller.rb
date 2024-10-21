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
      if user && user.authenticate(params[:session][:password])
        forwarding_url = session[:forwarding_url]
        reset_session
        log_in(user)
        remember(user) if params[:session][:remember_me] == "1"
        format.html { redirect_to forwarding_url || user, notice: "Login success." }
      else
        flash.now[:danger] = "Invalid email/password combination login"
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    log_out
    # redirect_to login_path
    redirect_to root_path
  end

  private
  def get_email
    params.require(:session).permit(:email)
  end
end
