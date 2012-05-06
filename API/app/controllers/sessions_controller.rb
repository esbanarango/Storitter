class SessionsController < ApplicationController

	respond_to :json

	# The user will be fetch on facebook in order to get back his fb_uid, if the fb_uid is not in database, 
	# then we create a new user using facebook provided fields
	def index
		if params["fb_access_token"]
			fb_access_token = params["fb_access_token"]
			graph = Koala::Facebook::API.new(fb_access_token)
			@user = graph.get_object("me")
			fb_uid = @user["id"]
			# Some FaceBook user's doesn't have username yet
			username = (@user["username"])?@user["username"]:@user["first_name"]
			if  !User.exists?(['fb_uid = ?', 'fb_uid'])
				newUser = User.create!(username: username, first_name: @user["first_name"], last_name: @user["last_name"], 
					email: @user["email"], fb_uid: fb_uid , fb_access_token: fb_access_token )
				#graph.put_wall_post("Me has just joined Storitter")
				Session.create!(access_token: fb_access_token, user_id: newUser.id)
			else
				#Update the fb_access_token
				userUpdate = User.where(fb_uid: fb_uid)
				userUpdate.fb_access_token = fb_access_token
				userUpdate.save
				userSession = Session.where(user_id: userUpdate.id)
				userSession.access_token = fb_access_token
				userSession.save
			end
			respond_with @user and fb_access_token
		end
	end

	def login
		if session['access_token']
			redirect_to "/home"
		else
			# generate a new oauth object with the app data and the callback url
			session['oauth'] = Koala::Facebook::OAuth.new(Facebook::APP_ID.to_s, Facebook::SECRET.to_s, Facebook::CALLBACK_URL.to_s + '/callback')
			redirect_to session['oauth'].url_for_oauth_code(:permissions => Facebook::PERMISSIONS)	
		end
	end

	#method to handle the redirect from facebook
	def callback
		unless params[:error_code] or params[:error] then
			#get the access token
			session['access_token'] = session['oauth'].get_access_token(params[:code])
		end
		redirect_to '/home'
	end

	def logout
	    session['oauth'] = nil
	    session['access_token'] = nil
	    redirect_to '/home'
	  end

	def home
	     if session['access_token']
	       @face='You are logged in! <a href="/logout">Logout</a>'
	       @graph = Koala::Facebook::API.new(session["access_token"])
	       @token = session['access_token']
	       #@graph.put_wall_post("Me has just joined Storitter")
	     else
	       @face='<a href="/login">Login</a>'
	     end

		
	end


end