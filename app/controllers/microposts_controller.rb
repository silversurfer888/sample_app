class MicropostsController < ApplicationController
  # Before doing any Micropost actions, check if user is signed in
  # by calling signed_in_user in sessions_helper.rb
  # apply this sign in check only for create/destroy actions
  before_action :signed_in_user, only: [:create, :destroy]

  # To destroy, user must be the "correct" user, not only signed in
  # correct_user defined in private functions below
  before_action :correct_user, only: :destroy

  def index
  end
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = [] # needs to be initalized since the static_pages/home view
                    # calls partials that reference @feed_items
                    # Must be set before calling that view.
                    # Normally set by static_pages_controller.rb, but here,
                    # our microposts_controller.rb is calling its view
      render 'static_pages/home'
    end
  end

  def destroy
  end
  
  
  private
  
    def micropost_params
      # strong params, require micropost to only permit the 'content' field
      # so no hacker can insert additional fields to modify
      params.require(:micropost).permit(:content)
    end
    
    
    # check if URL user is same as micropost's user; if not, redirect
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end