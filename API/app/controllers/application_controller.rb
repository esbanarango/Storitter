class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
  	session[:user_id] ? @current_user_id ||= User.find(session[:user_id]).id : nil
  end

end
