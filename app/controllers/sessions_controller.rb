class SessionsController < ApplicationController
  before_action :already_signed_in, only: [:new, :create]
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
  
  private
    #Before filters
    
    def already_signed_in
      redirect_to root_path if signed_in?
    end
  
end
