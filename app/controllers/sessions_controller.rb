class SessionsController < ApplicationController
  skip_before_filter :require_login

  def index
    render layout: 'login'
  end

  def create
    session[:current_user] = params[:email_or_id]
    redirect_to my_membership_path
  end

  def destroy
    session.clear if logged_in?
    redirect_to login_screen_path
  end

  private
  def logged_in?
    session[:current_user]
  end
end