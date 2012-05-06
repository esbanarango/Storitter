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
	    	respond_with({:response => "success"}, :location => posts_url)
	    else
	    	respond_with({:response => "error"}, :location => posts_url)
	    end
  	end

    #get
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

    #POST 
  	def follow
  		current_user = User.find(session[:user_id])
  		@user = User.find(params[:id])
  		if current_user.follow!(@user)

        if current_user.facebook_autoshare 
          shareOnFacebook(current_user.fb_access_token,"Me is now following #{@user.username} on Storitter")
        end

  			respond_with({:response => "success"}, :location => posts_url)
  		else
  			respond_with({:response => "error"}, :location => posts_url)
  		end
  	end

  	def delete_followers
  		current_user = User.find(session[:user_id])
  		@user = User.find(params[:id])
      relation = Relation.find_by_follower_id_and_following_id(@user.id,current_user.id)
      puts relation.inspect
  		relation.forbid = true
      if relation.save
        respond_with({:response => "ok"}, :location => posts_url)
      else
        respond_with({:response => "error"}, :location => posts_url)
      end
  	end

  	def delete_followings
  		current_user = User.find(session[:user_id])
  		@user = User.find(params[:id])
  		if current_user.unfollow!(@user)
        respond_with({:response => "ok"}, :location => posts_url)
      else
        respond_with({:response => "error"}, :location => posts_url)
      end
  	end

    private

    def shareOnFacebook (access_token,message)
      graph = Koala::Facebook::API.new(access_token)
      graph.put_wall_post(message)

    end


end