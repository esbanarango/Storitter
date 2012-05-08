class SessionsController < ApplicationController

	respond_to :json

	# The user will be fetch on facebook in order to get back his fb_uid, if the fb_uid is not in database, 
	# then we create a new user using facebook provided fields
	def index
		if params["fb_access_token"]
			fb_access_token = params["fb_access_token"]
			graph = Koala::Facebook::API.new(fb_access_token)
			@userFacebook = graph.get_object("me")
			checkOrInsert(graph,fb_access_token)
			respond_with @userFacebook
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
			graph = Koala::Facebook::API.new(session['access_token'])
			@userFacebook = graph.get_object("me")
			userEmail = @userFacebook["email"]
			fb_uid = @userFacebook["id"]

			checkOrInsert(graph,session['access_token'])

			@user  = User.find_by_email(userEmail)
			session[:user_id] = @user.id

		end
		redirect_to '/home'
	end

	def logout
	    session['oauth'] = nil
	    session['access_token'] = nil
	    session[:user_id] = nil
	    redirect_to '/home'
	  end

	def home
	     if session['access_token']
	       username = session["username"]
	       @face='Welcome '+ username +'<br> You are logged in! <a href="/logout">Logout</a>'
	       @graph = Koala::Facebook::API.new(session["access_token"])
	       @token = session['access_token']
	     else
	       @face='<a href="/login">Login</a>'
	     end
	end

	private

	# Returns false, if didn't insert a new user.
	def checkOrInsert(graph,fb_access_token)
		userFacebook = graph.get_object("me")
		fb_uid = userFacebook["id"]
		session["username"] = userFacebook["username"]
		if !User.exists?(['fb_uid = ?', fb_uid])
			puts "Nuevo Usuario"
			# Some FaceBook user's doesn't have username yet
			username = (userFacebook["username"])?userFacebook["username"]:userFacebook["first_name"].strip..gsub(/\s+/, "_")
			newUser = User.create!(username: username, first_name: userFacebook["first_name"], last_name: userFacebook["last_name"], 
						email: userFacebook["email"], fb_uid: fb_uid , fb_access_token: fb_access_token )
			graph.put_wall_post("Me has just joined Storitter")
			newUser.build_session(access_token: fb_access_token)
			newUser.save

		else
			userUpdate = User.find_by_fb_uid(fb_uid)
			userUpdate.fb_access_token = fb_access_token
			userUpdate.session.access_token = fb_access_token
			userUpdate.save
		end
		
	end


end