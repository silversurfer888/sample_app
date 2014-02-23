class RelationshipsController < ApplicationController
  # can't access these methods, must first pass signed_in_user test
  before_action :signed_in_user

  def create
    # parameter passed in is relationship_followed_id
    # Find who this followed person is
    @user = User.find(params[:relationship][:followed_id])
    # target user created in @user instance variable
    current_user.follow!(@user)

    # execute only 1 of lines below, depending on nature of request
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end

    #redirect_to @user # redirect to target user's page
                # same as redirecting to user_url
  end

  # to 'unfollow' someone, remove entry in Relationships table
  def destroy
    # assume it passed in the id for which specific relationship
    # pull its 'followed' variable and store into @user
    # get current user to unfollow this @user
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
    #redirect_to @user

  end
end