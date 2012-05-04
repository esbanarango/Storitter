class UsersController < ApplicationController


	respond_to :json

	def index
		@users = User.all
		respond_with @users
	end

	def destroy
	    if User.find(params[:id]).destroy
	    	respond_with "success"
	    end
  	end


	def followings
	    @user = User.find(params[:id])
	    @users = @user.following_users()
	    respond_with @users
  	end

  	def followers
	    @user = User.find(params[:id])
	    @users = @user.followers()
	    respond_with	@users
  	end

  	def follow
  		@user = User.find(params[:id])
  		current_user.follow!(@user)
  	end

  	def delete_followers
  		
  	end

  	def delete_followings
  		
  	end


end