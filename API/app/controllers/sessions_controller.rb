class SessionsController < ApplicationController

	def index
		if params["fb_access_token"]
			fb_access_token = params["fb_access_token"]
			graph = Koala::Facebook::API.new(fb_access_token)

			@user = graph.get_object("me")
			puts @user.inspect

			respond_to do |format|
			      format.json { render json: @user }
			end
		end
	end


end