class Profile < ActiveRecord::Base

	# Associations
	belongs_to :user
  	belongs_to :employee

  	validates :username, :presence => true
	validates :email, :presence => true


	# Callbacks
	before_save :truncated

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
