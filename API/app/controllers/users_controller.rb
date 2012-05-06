class UsersController < ApplicationController


	respond_to :json

	def index
		@users = User.all
		render_for_api :return_public, :json => @users, :root => :users
	end

	def show
		@user = User.find(params[:id])
		puts @user.inspect
		render_for_api :user_with_posts, :json => @user, :root => :user
	end

	def destroy
	    if User.find(params[:id]).destroy
	    	respond_with response: "success"
	    end
  	end


	def followings
	    @user = User.find(params[:id])
	    @users = @user.following_users()
	    render_for_api :return_info_follow, :json => @users, :root => :users
  	end

  	def followers
	    @user = User.find(params[:id])
	    @users = @user.followers()
	    render_for_api :return_info_follow, :json => @users, :root => :users
  	end

  	def follow
  		current_user = session[:user]
  		@user = User.find(params[:id])
  		current_user.follow!(@user)
  	end

  	def delete_followers
  		current_user = session[:user]
  		@user = User.find(params[:id])
  		current_user.relations(@user).forbid = true
  		current_user.save
  	end

  	def delete_followings
  		current_user = session[:user]
  		@user = User.find(params[:id])
  		current_user.unfollow!(@user)
  	end

end