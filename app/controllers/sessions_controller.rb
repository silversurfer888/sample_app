class SessionsController < ApplicationController

  
  def new
    
  end
  
  def create
    #render 'new'
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      
      sign_in user
      #redirect_to user
      redirect_back_or user
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = 'Invalid email/password combination' #not quite right!
      render 'new'
    end
  end
  
  # calls sessions_helper function sign_out, then redirects to root
  def destroy
    sign_out 
    redirect_to root_url
  end
end
