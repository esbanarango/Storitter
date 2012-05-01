class Profile < ActiveRecord::Base


  	validates :username, :presence => true
  	
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, :presence => true, length: { maximum: 255 }, :format => { with: VALID_EMAIL_REGEX },
					  :uniqueness => { case_sensitive: false }

	# Callbacks
	before_save :truncated
	before_save { |profile| profile.email = email.downcase }

	attr_accessible :profile_picture 
	has_attached_file :profile_picture, :styles => { :small => "100x100>", :medium => "300x300>", :large => "400x400>" }

	private

	# Longer username than 40 will be truncated
	def truncated
		if self[:username].size > 40
			self[:username] = self[:username][0..39]
		end
	end

end
