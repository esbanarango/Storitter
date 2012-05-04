class UserMailer < ActionMailer::Base
  default from: "storitter@storific.com"

  def registration_confirmation(user)
  	@user = user;
  	mail to: @user.email, subject: "Welcome to Storitter"
  end

end
