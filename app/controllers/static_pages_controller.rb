class StaticPagesController < ApplicationController
  def home
    # call helper function signed_in
    # if signed in, static_pages/home view says to let user create micropost
    # otherwise, static_pages/home view says to display welcome
    # @micropost = current_user.microposts.build if signed_in?
    
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
